import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/mixins/local_user_mixin.dart';
import 'package:donation_management/core/data/models/notification_data_dto.dart';
import 'package:donation_management/core/data/services/firebase_messaging_service.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/feature/events/data/enums/event_status.dart';
import 'package:donation_management/feature/events/data/enums/event_type.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/data/models/joined_event_dto.dart';
import 'package:donation_management/feature/events/domain/event_repository.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> with LocalUserMixin {
  EventCubit(
    this._eventRepository,
    this._userRepository,
  ) : super(EventInitial());

  final EventRepositoryImpl _eventRepository;
  final UserRepositoryImpl _userRepository;

  Stream<QuerySnapshot>? getPostedEvent({
    required String postedBy,
    required EventType eventType,
    required EventStatus eventStatus,
  }) =>
      _eventRepository.getPostedEventByType(
        postedBy: postedBy,
        eventType: eventType,
        eventStatus: eventStatus,
      );

  Stream<DocumentSnapshot>? getEventDataStream(String eventId) =>
      _eventRepository.getEventStream(eventId);

  Stream<QuerySnapshot>? getMyListing(String userId, EventStatus eventStatus) =>
      _eventRepository.getUserJoinedEvents(userId, eventStatus);

  Stream<QuerySnapshot>? getEvents() => _eventRepository.getEvents();

  Stream<QuerySnapshot>? getParticipants(String eventId) =>
      _eventRepository.getParticipants(eventId);

  Future<EventDto>? getEventDataFuture(String eventId) =>
      _eventRepository.getEventFuture(eventId);

  Future<JoinedEventDto?> checkIfUserJoinedToEvent({
    required String userId,
    required String eventId,
  }) async =>
      await _eventRepository.checkIfUserJoinedToEvent(
          userId: userId, eventId: eventId);

  Future<void> addEvent(FormGroup form, XFile eventPhoto) async {
    emit(const EventLoading());

    try {
      UserDto user = await loadLocalUser();

      String eventId = StringUtils.generateId();

      String? eventPhotoUrl = await _eventRepository.uploadEventPhoto(
        eventId: eventId,
        uploadedFile: eventPhoto.path,
      );

      DateTime sd = form.control('eventStartDate').value as DateTime;
      TimeOfDay st = form.control('eventStartTime').value as TimeOfDay;

      DateTime ed = form.control('eventEndDate').value as DateTime;
      TimeOfDay et = form.control('eventEndTime').value as TimeOfDay;

      DateTime eventStartDateTime = DateTime(
        sd.year,
        sd.month,
        sd.day,
        st.hour,
        st.minute,
      );

      DateTime eventEndDateTime = DateTime(
        ed.year,
        ed.month,
        ed.day,
        et.hour,
        et.minute,
      );

      EventDto eventData = EventDto(
        eventId: eventId,
        postedBy: user.userId,
        eventType: EventType.donationDrive.code(),
        eventStatus: EventStatus.notYetStarted.code(),
        eventTitle: form.control('eventTitle').value,
        eventDescription: form.control('eventDescription').value,
        eventPhotoUrl: eventPhotoUrl,
        eventStartDateTime: eventStartDateTime,
        eventEndDateTime: eventEndDateTime,
        isDonationClosed: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _eventRepository.addEvent(
        eventData.eventId!,
        event: eventData,
      );

      emit(EventSuccess());
    } catch (err) {
      if (err is SocketException) {
        emit(const EventError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const EventError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  Future<void> updateEvent(
    FormGroup form,
    XFile? eventPhoto,
    EventDto event,
  ) async {
    emit(const EventLoading());

    try {
      String? eventPhotoUrl;
      bool updateJoinedEvents = false;

      if (eventPhoto != null) {
        eventPhotoUrl = await _eventRepository.uploadEventPhoto(
          eventId: event.eventId!,
          uploadedFile: eventPhoto.path,
        );
      } else {
        eventPhotoUrl = event.eventPhotoUrl;
      }

      DateTime sd = form.control('eventStartDate').value as DateTime;
      TimeOfDay st = form.control('eventStartTime').value as TimeOfDay;

      DateTime ed = form.control('eventEndDate').value as DateTime;
      TimeOfDay et = form.control('eventEndTime').value as TimeOfDay;

      DateTime eventStartDateTime = DateTime(
        sd.year,
        sd.month,
        sd.day,
        st.hour,
        st.minute,
      );

      DateTime eventEndDateTime = DateTime(
        ed.year,
        ed.month,
        ed.day,
        et.hour,
        et.minute,
      );

      num eventStatus = event.eventStatus!;

      if (eventStartDateTime != event.eventStartDateTime ||
          eventEndDateTime != event.eventEndDateTime) {
        eventStatus = EventStatus.rescheduled.code();
        updateJoinedEvents = true;
      }

      EventDto eventData = EventDto(
        eventId: event.eventId,
        postedBy: event.postedBy,
        eventStatus: eventStatus,
        eventType: EventType.donationDrive.code(),
        eventTitle: form.control('eventTitle').value,
        eventDescription: form.control('eventDescription').value,
        eventPhotoUrl: eventPhotoUrl,
        eventStartDateTime: eventStartDateTime,
        eventEndDateTime: eventEndDateTime,
        updatedAt: DateTime.now(),
      );

      await _eventRepository.updateEvent(
        eventData.eventId!,
        event: eventData,
      );

      if (updateJoinedEvents) {
        await _updateJoinedEvents(
          eventData.eventId!,
          eventStatus: getEventStatusEnum(eventStatus),
        );
      }

      if (eventStatus == EventStatus.rescheduled.code()) {
        String newSDT = StringUtils.getFormattedDate(
          dateTime: eventStartDateTime,
          dateFormat: 'MMMM dd, yyyy hh:mm a',
        );

        String newEDT = StringUtils.getFormattedDate(
          dateTime: eventEndDateTime,
          dateFormat: 'MMMM dd, yyyy hh:mm a',
        );

        String notificationBodyText =
            'The donation drive ${event.eventTitle} is rescheduled to $newSDT to $newEDT. Please contact the organization for more details.';

        await _broadcastEventUpdate(
          event.eventId!,
          title: 'Donation drive rescheduled.',
          body: notificationBodyText,
        );
      }

      emit(EventSuccess());
    } catch (err) {
      if (err is SocketException) {
        emit(const EventError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const EventError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  void populateEventData(EventDto event, FormGroup form) {
    DateTime sD = event.eventStartDateTime!;
    DateTime eD = event.eventEndDateTime!;

    form.reset(
      value: {
        'eventType': event.eventType,
        'eventTitle': event.eventTitle,
        'eventDescription': event.eventDescription,
        'eventStartDate': DateTime(sD.year, sD.month, sD.day),
        'eventStartTime': TimeOfDay(hour: sD.hour, minute: sD.minute),
        'eventEndDate': DateTime(eD.year, eD.month, eD.day),
        'eventEndTime': TimeOfDay(hour: eD.hour, minute: eD.minute),
      },
    );

    if (event.eventStatus == EventStatus.onGoing.code()) {
      form.control('eventStartDate').markAsDisabled();
      form.control('eventStartTime').markAsDisabled();
      form.control('eventEndDate').markAsDisabled();
      form.control('eventEndTime').markAsDisabled();
    }

    emit(EventPhotoFetched(eventPhoto: event.eventPhotoUrl));
  }

  Future<void> listEvent({
    required String eventId,
    required String eventCreatedBy,
    required num eventStatus,
    required String userId,
  }) async {
    emit(const EventLoading(preventBuild: true));

    try {
      JoinedEventDto joinedEvent = JoinedEventDto(
        id: StringUtils.generateId(),
        joinedEventId: eventId,
        eventCreatedBy: eventCreatedBy,
        joinedBy: userId,
        joinedEventStatus: eventStatus,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _eventRepository.listEvent(
        joinedEvent.id!,
        joinedEvent: joinedEvent,
      );

      emit(const EventListUnlistSuccess());
    } catch (err) {
      if (err is SocketException) {
        emit(const EventError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const EventError(errorMessage: 'Oops! Something went wrong.'));
      }
    }
  }

  Future<void> unlistEvent({
    required String eventId,
    required String userId,
  }) async {
    emit(const EventLoading(preventBuild: true));

    try {
      JoinedEventDto? joinedEvent =
          await _eventRepository.checkIfUserJoinedToEvent(
        eventId: eventId,
        userId: userId,
      );

      await _eventRepository.unlistEvent(joinedEvent!.id!);

      emit(const EventListUnlistSuccess(forUnlisting: true));
    } catch (err) {
      if (err is SocketException) {
        emit(const EventError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const EventError(errorMessage: 'Oops! Something went wrong.'));
      }
    }
  }

  Future<void> changeEventStatus(
    EventDto event,
    EventStatus eventStatus,
  ) async {
    emit(const EventLoading(preventBuild: true));

    try {
      String? message = 'Success!';

      bool isDonationClosed = false;

      if (eventStatus == EventStatus.completed ||
          eventStatus == EventStatus.cancelled) {
        isDonationClosed = true;
      } else {
        isDonationClosed = false;
      }

      EventDto eventData = EventDto(
        eventId: event.eventId,
        isDonationClosed: isDonationClosed,
        eventStatus: eventStatus.code(),
        updatedAt: DateTime.now(),
      );

      await _eventRepository.updateEvent(
        eventData.eventId!,
        event: eventData,
      );

      await _updateJoinedEvents(eventData.eventId!, eventStatus: eventStatus);

      if (eventStatus == EventStatus.cancelled) {
        message = 'Event cancelled!';

        String notificationBodyText =
            'Apologies, the donation drive ${event.eventTitle} is already cancelled. Please contact the organization for more details.';

        await _broadcastEventUpdate(
          event.eventId!,
          title: 'Donation drive cancelled.',
          body: notificationBodyText,
        );
      } else if (eventStatus == EventStatus.onGoing) {
        message = 'Event started!';
      } else if (eventStatus == EventStatus.completed) {
        message = 'Event completed!';
      }

      emit(EventChangeStatusSuccess(message: message));
    } catch (err) {
      if (err is SocketException) {
        emit(const EventError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const EventError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  Future<void> closeReOpenDonation(
    String eventId,
    bool isDonationClosed,
  ) async {
    emit(const EventLoading(preventBuild: true));

    try {
      EventDto eventData = EventDto(
        eventId: eventId,
        isDonationClosed: isDonationClosed,
        updatedAt: DateTime.now(),
      );

      await _eventRepository.updateEvent(eventData.eventId!, event: eventData);

      emit(EventChangeStatusSuccess(
        message:
            (isDonationClosed) ? 'Donations closed!' : 'Donations re-opened!',
      ));
    } catch (err) {
      if (err is SocketException) {
        emit(const EventError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const EventError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  Future<void> _updateJoinedEvents(
    String eventId, {
    EventStatus? eventStatus,
  }) async {
    List<JoinedEventDto> joinedEvents =
        await _eventRepository.getJoinedEvents(eventId);

    if (joinedEvents.isNotEmpty) {
      for (JoinedEventDto element in joinedEvents) {
        JoinedEventDto newData = JoinedEventDto(
          id: element.id,
          joinedEventStatus: eventStatus!.code(),
          updatedAt: DateTime.now(),
        );

        await _eventRepository.updateJoinedEvent(newData);
      }
    }
  }

  Future<void> _broadcastEventUpdate(
    String eventId, {
    required String title,
    required String body,
  }) async {
    List<JoinedEventDto> joinedEvents =
        await _eventRepository.getJoinedEvents(eventId);

    for (var joinedEvent in joinedEvents) {
      UserDto user = await _userRepository.getUser(joinedEvent.joinedBy!);

      final notification = NotificationDto(
        fcmToken: user.fcmToken ?? '',
        body: NotificationBodyDto(
          title: title,
          body: body,
        ).toJson(),
      ).toJson();

      await FirebaseMessagingService.sendPushMessage(
        jsonEncode(notification),
      );
    }
  }
}
