import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:donation_management/feature/events/data/enums/donation_offer_status.dart';
import 'package:donation_management/feature/events/data/enums/donation_type.dart';
import 'package:donation_management/feature/events/data/models/donation_dto.dart';
import 'package:donation_management/feature/events/data/models/donation_offer_dto.dart';

abstract class DonationRepository {
  /// Fetch donations based on donation type
  Stream<QuerySnapshot>? fetchDonations(
    String eventId, {
    DonationType donationType = DonationType.material,
  });

  /// Add donation
  Future<void> addDonation(DonationDto donation, String eventId);

  /// Update donation to `firestore`.
  Future<void> updateDonation(DonationDto donation, String eventId);

  /// Get donation
  Future<DonationDto?> getDonation({
    required String eventId,
    required String donationId,
  });

  /// Get all donation
  Future<List<DonationDto>?> getDonations(
    String eventId,
    DonationType donationType,
  );

  /// Get all donation offers
  Future<List<DonationOfferDto>?> getDonationsOffers(
    String eventId,
    DonationOfferStatus donationOfferStatus,
  );

  /// Get donation offers
  Stream<QuerySnapshot>? fetchDonationOffers({
    required String userId,
    required String eventId,
  });

  /// Update donation offer to `firestore`.
  Future<void> updateDonationOffer(DonationOfferDto donationOffer);

  /// Add donation offer
  Future<void> addDonationOffer(DonationOfferDto donationOfferDto);

  Future<bool> checkDonactionAlreadyExist(DonationDto donation, String eventId);
}

class DonationRepositoryImpl implements DonationRepository {
  const DonationRepositoryImpl(this._firebaseService);

  final FirebaseService _firebaseService;

  @override
  Stream<QuerySnapshot>? fetchDonations(
    String eventId, {
    DonationType donationType = DonationType.material,
  }) =>
      _firebaseService.eventsRef
          .doc(eventId)
          .collection('donations')
          .where('donationType', isEqualTo: donationType.code())
          .orderBy('createdAt', descending: true)
          .snapshots();

  @override
  Future<void> addDonation(DonationDto donation, String eventId) =>
      _firebaseService.eventsRef
          .doc(eventId)
          .collection('donations')
          .doc(donation.donationId)
          .set(donation.toJson());

  @override
  Future<void> updateDonation(DonationDto donation, String eventId) async =>
      await _firebaseService.eventsRef
          .doc(eventId)
          .collection('donations')
          .doc(donation.donationId)
          .update(donation.toJson());

  @override
  Future<DonationDto?> getDonation({
    required String eventId,
    required String donationId,
  }) async {
    DocumentSnapshot query = await _firebaseService.eventsRef
        .doc(eventId)
        .collection('donations')
        .doc(donationId)
        .get();

    return (query.data() != null)
        ? DonationDto.fromJson(query.data() as Map<String, dynamic>)
        : null;
  }

  @override
  Future<bool> checkDonactionAlreadyExist(
      DonationDto donation, String eventId) async {
    CollectionReference donationsRef =
        _firebaseService.eventsRef.doc(eventId).collection('donations');

    // Convert the donation name to lowercase for case-insensitive comparison
    String lowercasedDonationName = donation.donationName!.toLowerCase();

    QuerySnapshot querySnapshot = await donationsRef.get();

    // Check if any existing donation name matches the lowercase version of the new donation name
    bool donationExists = querySnapshot.docs.any((doc) {
      // Explicitly cast doc.data() to Map<String, dynamic>
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Access the 'donationName' property using []
      String existingDonationName =
          (data['donationName'] as String).toLowerCase();
      return existingDonationName == lowercasedDonationName;
    });

    return donationExists;
  }

  @override
  Future<List<DonationDto>?> getDonations(
      String eventId, DonationType donationType) async {
    List<DonationDto> _donations = <DonationDto>[];

    QuerySnapshot query = await _firebaseService.eventsRef
        .doc(eventId)
        .collection('donations')
        .where('donationType', isEqualTo: donationType.code())
        .orderBy('createdAt', descending: true)
        .get();

    for (QueryDocumentSnapshot element in query.docs) {
      _donations.add(
        DonationDto.fromJson(
          element.data() as Map<String, dynamic>,
        ),
      );
    }

    return _donations;
  }

  @override
  Future<List<DonationOfferDto>?> getDonationsOffers(
    String eventId,
    DonationOfferStatus donationOfferStatus,
  ) async {
    List<DonationOfferDto> _donationOffers = <DonationOfferDto>[];

    QuerySnapshot query = await _firebaseService.donationOffersRef
        .where('eventId', isEqualTo: eventId)
        .where('status', isEqualTo: donationOfferStatus.code())
        .orderBy('createdAt', descending: true)
        .get();

    for (QueryDocumentSnapshot element in query.docs) {
      _donationOffers.add(
        DonationOfferDto.fromJson(
          element.data() as Map<String, dynamic>,
        ),
      );
    }

    return _donationOffers;
  }

  @override
  Stream<QuerySnapshot>? fetchDonationOffers({
    required String userId,
    required String eventId,
  }) =>
      _firebaseService.donationOffersRef
          .where('donatedBy', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .orderBy('createdAt', descending: true)
          .snapshots();

  @override
  Future<void> updateDonationOffer(DonationOfferDto donationOffer) async =>
      await _firebaseService.donationOffersRef
          .doc(donationOffer.donationOfferId)
          .update(donationOffer.toJson());

  @override
  Future<void> addDonationOffer(DonationOfferDto donationOfferDto) =>
      _firebaseService.donationOffersRef
          .doc(donationOfferDto.donationOfferId)
          .set(donationOfferDto.toJson());
}
