import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/mixins/local_user_mixin.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/feature/events/data/enums/event_type.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/data/models/joined_event_dto.dart';
import 'package:donation_management/feature/events/domain/event_repository.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> with LocalUserMixin {
  EventCubit(
    this._eventRepository,
  ) : super(EventInitial());

  final EventRepositoryImpl _eventRepository;

  Stream<QuerySnapshot>? getPostedEvent({
    required String postedBy,
    required EventType eventType,
  }) =>
      _eventRepository.getPostedEventByType(
          postedBy: postedBy, eventType: eventType);

  Stream<DocumentSnapshot>? getEventDataStream(String eventId) =>
      _eventRepository.getEventStream(eventId);

  Stream<QuerySnapshot>? getMyListing(String eventId) =>
      _eventRepository.getUserJoinedEvents(eventId);

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

      EventDto eventData = EventDto(
        eventId: eventId,
        postedBy: user.userId,
        eventType: form.control('eventType').value,
        eventTitle: form.control('eventTitle').value,
        eventDescription: form.control('eventDescription').value,
        eventPhotoUrl: eventPhotoUrl,
        eventDate: form.control('eventDate').value,
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

      if (eventPhoto != null) {
        eventPhotoUrl = await _eventRepository.uploadEventPhoto(
          eventId: event.eventId!,
          uploadedFile: eventPhoto.path,
        );
      } else {
        eventPhotoUrl = event.eventPhotoUrl;
      }

      EventDto eventData = EventDto(
        eventId: event.eventId,
        postedBy: event.postedBy,
        eventType: form.control('eventType').value,
        eventTitle: form.control('eventTitle').value,
        eventDescription: form.control('eventDescription').value,
        eventDate: form.control('eventDate').value,
        eventPhotoUrl: eventPhotoUrl,
        updatedAt: DateTime.now(),
      );

      await _eventRepository.updateEvent(
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

  void populateEventData(EventDto event, FormGroup form) {
    form.reset(
      value: {
        'eventType': event.eventType,
        'eventTitle': event.eventTitle,
        'eventDescription': event.eventDescription,
        'eventDate': event.eventDate,
      },
    );

    emit(EventPhotoFetched(eventPhoto: event.eventPhotoUrl));
  }

  Future<void> deleteEvent(String eventId, String eventPhotoUrl) async {
    emit(const EventLoading(preventBuild: true));

    try {
      await _eventRepository.deleteEvent(eventId);

      await _eventRepository.deleteEventPhoto(eventPhotoUrl);

      List<JoinedEventDto> joinedEvents =
          await _eventRepository.getJoinedEvents(eventId);

      if (joinedEvents.isNotEmpty) {
        for (JoinedEventDto element in joinedEvents) {
          await _eventRepository.deleteJoinedEvent(element.id!);
        }
      }

      emit(EventDeleteSuccess());
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

  Future<void> listEvent({
    required String eventId,
    required String eventCreatedBy,
    required String userId,
  }) async {
    emit(const EventLoading(preventBuild: true));

    try {
      JoinedEventDto joinedEvent = JoinedEventDto(
        id: StringUtils.generateId(),
        joinedEventId: eventId,
        eventCreatedBy: eventCreatedBy,
        joinedBy: userId,
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
}
