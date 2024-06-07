import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';

enum EventStatus { notYetStarted, onGoing, rescheduled, completed, cancelled }

extension EventStatusExt on EventStatus {
  int code() {
    switch (this) {
      case EventStatus.notYetStarted:
        return 1;
      case EventStatus.onGoing:
        return 2;
      case EventStatus.rescheduled:
        return 3;
      case EventStatus.completed:
        return 4;
      default:
        return 5;
    }
  }

  String text() {
    switch (this) {
      case EventStatus.notYetStarted:
        return 'Pending';
      case EventStatus.onGoing:
        return 'On Going';
      case EventStatus.rescheduled:
        return 'Rescheduled';
      case EventStatus.completed:
        return 'Completed';
      default:
        return 'Cancelled';
    }
  }
}

EventStatus getEventStatusEnum(num eventStatus) {
  switch (eventStatus) {
    case 1:
      return EventStatus.notYetStarted;
    case 2:
      return EventStatus.onGoing;
    case 3:
      return EventStatus.rescheduled;
    case 4:
      return EventStatus.completed;
    default:
      return EventStatus.cancelled;
  }
}

String getEventStatus(num eventStatus) {
  switch (eventStatus) {
    case 1:
      return 'Pending';
    case 2:
      return 'On Going';
    case 3:
      return 'Rescheduled';
    case 4:
      return 'Completed';
    default:
      return 'Cancelled';
  }
}

Color getEventStatusColor(num eventStatus) {
  switch (eventStatus) {
    case 1:
      return AppStyle.kColorGrey;
    case 2:
      return AppStyle.kColorBlue;
    case 3:
      return AppStyle.kColorBlue;
    case 4:
      return AppStyle.kPrimaryColor;
    default:
      return AppStyle.kColorRed;
  }
}
