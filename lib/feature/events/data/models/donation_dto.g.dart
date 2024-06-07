// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationDto _$DonationDtoFromJson(Map<String, dynamic> json) => DonationDto(
      donationId: json['donationId'] as String?,
      donationName: json['donationName'] as String?,
      donationQuantity: json['donationQuantity'] as num?,
      donationTargetQuantity: json['donationTargetQuantity'] as num?,
      donationType: json['donationType'] as num?,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$DonationDtoToJson(DonationDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('donationId', instance.donationId);
  writeNotNull('donationName', instance.donationName);
  writeNotNull('donationQuantity', instance.donationQuantity);
  writeNotNull('donationTargetQuantity', instance.donationTargetQuantity);
  writeNotNull('donationType', instance.donationType);
  writeNotNull(
      'createdAt', const TimestampConverter().toJson(instance.createdAt));
  writeNotNull(
      'updatedAt', const TimestampConverter().toJson(instance.updatedAt));
  return val;
}
