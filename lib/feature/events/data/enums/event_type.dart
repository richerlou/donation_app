enum EventType { donationDrive, volunteer }

extension EventTypeExt on EventType {
  int code() {
    switch (this) {
      case EventType.donationDrive:
        return 1;
      default:
        return 2;
    }
  }

  String text() {
    switch (this) {
      case EventType.donationDrive:
        return 'Donation Drive';
      default:
        return 'Volunteer';
    }
  }
}

String getEventType(num eventTypeValue) {
  switch (eventTypeValue) {
    case 1:
      return 'Donation Drive';
    default:
      return 'Volunteer';
  }
}
