enum DonationType { service, material }

extension DonationTypeExt on DonationType {
  int code() {
    switch (this) {
      case DonationType.service:
        return 1;
      default:
        return 2;
    }
  }

  String text() {
    switch (this) {
      case DonationType.service:
        return 'Services';
      default:
        return 'Materials';
    }
  }
}

String getDonationType(num donationTypeValue) {
  switch (donationTypeValue) {
    case 1:
      return 'Services';
    default:
      return 'Materials';
  }
}
