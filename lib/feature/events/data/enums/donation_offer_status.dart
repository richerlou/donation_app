enum DonationOfferStatus { pending, approved, declined }

extension DonationOfferStatusExt on DonationOfferStatus {
  int code() {
    switch (this) {
      case DonationOfferStatus.pending:
        return 1;
      case DonationOfferStatus.approved:
        return 2;
      default:
        return 3;
    }
  }

  String text() {
    switch (this) {
      case DonationOfferStatus.pending:
        return 'Pending';
      case DonationOfferStatus.approved:
        return 'Approved';
      default:
        return 'Declined';
    }
  }
}

String getDonationOfferStatus(num value) {
  switch (value) {
    case 1:
      return 'Pending';
    case 2:
      return 'Approved';
    default:
      return 'Declined';
  }
}
