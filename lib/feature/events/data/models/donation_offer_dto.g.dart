// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationOfferDto _$DonationOfferDtoFromJson(Map<String, dynamic> json) =>
    DonationOfferDto(
      donationOfferId: json['donationOfferId'] as String?,
      eventId: json['eventId'] as String?,
      itemId: json['itemId'] as String?,
      donatedBy: json['donatedBy'] as String?,
      quantity: json['quantity'] as num?,
      status: json['status'] as num?,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$DonationOfferDtoToJson(DonationOfferDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('donationOfferId', instance.donationOfferId);
  writeNotNull('eventId', instance.eventId);
  writeNotNull('itemId', instance.itemId);
  writeNotNull('donatedBy', instance.donatedBy);
  writeNotNull('quantity', instance.quantity);
  writeNotNull('status', instance.status);
  writeNotNull(
      'createdAt', const TimestampConverter().toJson(instance.createdAt));
  writeNotNull(
      'updatedAt', const TimestampConverter().toJson(instance.updatedAt));
  return val;
}
