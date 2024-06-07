import 'package:json_annotation/json_annotation.dart';
part 'notification_data_dto.g.dart';

@JsonSerializable()
class NotificationDto {
  @JsonKey(name: 'to')
  String fcmToken;

  @JsonKey(name: 'notification')
  final Map<String, dynamic> body;

  @JsonKey(name: 'data')
  final Map<String, dynamic>? data;

  NotificationDto({
    required this.fcmToken,
    required this.body,
    this.data,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
}

@JsonSerializable()
class NotificationBodyDto {
  final String title;
  final String body;

  NotificationBodyDto({
    required this.title,
    required this.body,
  });

  factory NotificationBodyDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationBodyDtoToJson(this);
}

@JsonSerializable()
class NotificationDataDto {
  final String action;

  NotificationDataDto({
    required this.action,
  });

  factory NotificationDataDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataDtoToJson(this);
}
