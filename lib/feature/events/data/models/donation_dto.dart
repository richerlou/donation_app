import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'donation_dto.g.dart';

@JsonSerializable()
class DonationDto {
  @JsonKey(name: 'donationId', includeIfNull: false)
  final String? donationId;

  @JsonKey(name: 'donationName', includeIfNull: false)
  final String? donationName;

  @JsonKey(name: 'donationQuantity', includeIfNull: false)
  final num? donationQuantity;

  @JsonKey(name: 'donationTargetQuantity', includeIfNull: false)
  final num? donationTargetQuantity;

  @JsonKey(name: 'donationType', includeIfNull: false)
  final num? donationType;

  @JsonKey(name: 'createdAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? updatedAt;

  DonationDto({
    this.donationId,
    this.donationName,
    this.donationQuantity,
    this.donationTargetQuantity,
    this.donationType,
    this.createdAt,
    this.updatedAt,
  });

  factory DonationDto.fromJson(Map<String, dynamic> json) =>
      _$DonationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DonationDtoToJson(this);
}
