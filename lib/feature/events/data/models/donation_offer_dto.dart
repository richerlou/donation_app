import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'donation_offer_dto.g.dart';

@JsonSerializable()
class DonationOfferDto {
  @JsonKey(name: 'donationOfferId', includeIfNull: false)
  final String? donationOfferId;

  @JsonKey(name: 'eventId', includeIfNull: false)
  final String? eventId;

  @JsonKey(name: 'itemId', includeIfNull: false)
  final String? itemId;

  @JsonKey(name: 'donatedBy', includeIfNull: false)
  final String? donatedBy;

  @JsonKey(name: 'quantity', includeIfNull: false)
  final num? quantity;

  @JsonKey(name: 'status', includeIfNull: false)
  final num? status;

  @JsonKey(name: 'createdAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? updatedAt;

  DonationOfferDto({
    this.donationOfferId,
    this.eventId,
    this.itemId,
    this.donatedBy,
    this.quantity,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory DonationOfferDto.fromJson(Map<String, dynamic> json) =>
      _$DonationOfferDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DonationOfferDtoToJson(this);
}
