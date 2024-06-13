import 'dart:convert';
import 'dart:io';
import 'package:donation_management/core/data/services/custom_emailjs.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/mixins/local_user_mixin.dart';
import 'package:donation_management/core/data/models/notification_data_dto.dart';
import 'package:donation_management/core/data/services/firebase_messaging_service.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/feature/events/data/enums/donation_offer_status.dart';
import 'package:donation_management/feature/events/data/enums/donation_type.dart';
import 'package:donation_management/feature/events/data/models/donation_dto.dart';
import 'package:donation_management/feature/events/data/models/donation_offer_dto.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/domain/donation_repository.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'donation_state.dart';

class DonationCubit extends Cubit<DonationState> with LocalUserMixin {
  DonationCubit(
    this._donationRepository,
    this._userRepository,
  ) : super(DonationInitial());

  final DonationRepositoryImpl _donationRepository;
  final UserRepositoryImpl _userRepository;

  Stream<QuerySnapshot>? fetchDonations(
    String eventId, {
    DonationType donationType = DonationType.service,
  }) =>
      _donationRepository.fetchDonations(eventId, donationType: donationType);

  Stream<QuerySnapshot>? fetchDonationOffers({
    required String userId,
    required String eventId,
  }) =>
      _donationRepository.fetchDonationOffers(userId: userId, eventId: eventId);

  Future<DonationDto?> getDonation({
    required String eventId,
    required String donationId,
  }) async =>
      await _donationRepository.getDonation(
          eventId: eventId, donationId: donationId);

  Future<void> addDonation(
    FormGroup form,
    String eventId,
    bool forMaterial,
  ) async {
    emit(DonationLoading());

    try {
      String donationId = StringUtils.generateId();

      DonationDto donation = DonationDto(
        donationId: donationId,
        donationName: form.control('donationName').value,
        donationQuantity: 0,
        donationTargetQuantity: form.control('donationTargetQuantity').value,
        donationType: (forMaterial)
            ? DonationType.material.code()
            : DonationType.service.code(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool donationExists = await _donationRepository
          .checkDonactionAlreadyExist(donation, eventId);

      if (donationExists) {
        // Throw a specific error if the donation already exists
        throw DonationAlreadyExistsError();
      }

      await _donationRepository.addDonation(donation, eventId);

      emit(const DonationSuccess());
    } catch (err) {
      if (err is SocketException) {
        emit(const DonationError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else if (err is DonationAlreadyExistsError) {
        emit(const DonationError(
          errorMessage: 'Donation with the same name already exists.',
        ));
      } else {
        emit(const DonationError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  Future<void> updateDonationOffer(
    UserDto donor,
    EventDto event,
    DonationOfferDto donationOffer,
    DonationOfferStatus donationOfferStatus,
  ) async {
    emit(DonationLoading());

    num currentQty;

    Map<String, dynamic> notification;

    String message = 'None';
    String notificationTitleText;
    String notificationBodyText;

    String eventStartDateTime = StringUtils.getFormattedDate(
      dateTime: event.eventStartDateTime,
      dateFormat: 'MMMM dd, yyyy hh:mm a',
    );

    String eventEndDateTime = StringUtils.getFormattedDate(
      dateTime: event.eventEndDateTime,
      dateFormat: 'MMMM dd, yyyy hh:mm a',
    );

    DonationOfferDto newOffer = DonationOfferDto(
      donationOfferId: donationOffer.donationOfferId,
      status: donationOfferStatus.code(),
      updatedAt: DateTime.now(),
    );

    try {
      await _donationRepository.updateDonationOffer(newOffer);

      DonationDto? currentDonation = await _donationRepository.getDonation(
        eventId: donationOffer.eventId!,
        donationId: donationOffer.itemId!,
      );

      currentQty = currentDonation!.donationQuantity ?? 0;

      if (donationOfferStatus == DonationOfferStatus.approved) {
        message = 'Donation approved!';

        DonationDto newDonation = DonationDto(
          donationId: donationOffer.itemId,
          donationQuantity: currentQty += donationOffer.quantity!,
          updatedAt: DateTime.now(),
        );

        await _donationRepository.updateDonation(
          newDonation,
          donationOffer.eventId!,
        );

        notificationTitleText = 'Your donations are approved.';
        notificationBodyText =
            'Your donation ${currentDonation.donationName} with the quantity of ${donationOffer.quantity} to ${event.eventTitle} on $eventStartDateTime to $eventEndDateTime are approved.';
        // Send email notification
        await CustomEmailJS.send(
          serviceID: 'service_fw7sh7g', // replace with your EmailJS service ID
          templateID:
              'template_1q6w5vt', // replace with your EmailJS template ID
          templateParams: {
            'to': donor.emailAddress,
            'subject': 'Your donation has been approved!',
            'message': notificationBodyText,
          },
        );
      } else {
        message = 'Donation declined!';
        notificationTitleText = 'Your donations are declined.';
        notificationBodyText =
            'Your donation ${currentDonation.donationName} with the quantity of ${donationOffer.quantity} to ${event.eventTitle} on $eventStartDateTime to $eventEndDateTime are declined.';
      }

      notification = NotificationDto(
        fcmToken: donor.fcmToken ?? '',
        body: NotificationBodyDto(
          title: notificationTitleText,
          body: notificationBodyText,
        ).toJson(),
      ).toJson();

      await FirebaseMessagingService.sendPushMessage(jsonEncode(notification));

      emit(DonationSuccess(message: message));
    } catch (err) {
      if (err is SocketException) {
        emit(const DonationError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const DonationError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  Future<void> getDonations(String eventId, DonationType donationType) async {
    emit(DonationLoading());

    try {
      List<DropdownMenuItem<DonationDto>> _dropdownItems =
          <DropdownMenuItem<DonationDto>>[];

      List<DonationDto>? donations =
          await _donationRepository.getDonations(eventId, donationType);

      for (DonationDto donation in donations!) {
        _dropdownItems.add(
          DropdownMenuItem<DonationDto>(
            value: donation,
            child: Text(donation.donationName!),
          ),
        );
      }

      emit(DonationSuccess(donations: _dropdownItems));
    } catch (err) {
      if (err is SocketException) {
        emit(const DonationError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const DonationError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  Future<void> addDonationOffer({
    required EventDto event,
    required FormGroup form,
  }) async {
    emit(DonationLoading());

    try {
      UserDto user = await loadLocalUser();
      String donationOfferId = StringUtils.generateId();

      DonationDto selectedItem = form.control('item').value as DonationDto;

      DonationOfferDto offer = DonationOfferDto(
        donationOfferId: donationOfferId,
        eventId: event.eventId,
        itemId: selectedItem.donationId,
        quantity: form.control('quantity').value,
        donatedBy: user.userId,
        status: DonationOfferStatus.pending.code(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _donationRepository.addDonationOffer(offer);

      final orgUser = await _userRepository.getUser(event.postedBy!);
      final forApproval = await _donationRepository.getDonationsOffers(
        event.eventId!,
        DonationOfferStatus.pending,
      );

      Map<String, dynamic> notification = NotificationDto(
        fcmToken: orgUser.fcmToken ?? '',
        body: NotificationBodyDto(
          title: 'Hello ${orgUser.organizationName}!',
          body: 'You have ${forApproval!.length} donations to approve.',
        ).toJson(),
      ).toJson();

      await FirebaseMessagingService.sendPushMessage(
        jsonEncode(notification),
      );

      emit(const DonationSuccess(forDonationOffer: true));
    } catch (err) {
      if (err is SocketException) {
        emit(const DonationError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const DonationError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }
}
