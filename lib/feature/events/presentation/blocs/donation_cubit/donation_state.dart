part of 'donation_cubit.dart';

abstract class DonationState extends Equatable {
  const DonationState();

  @override
  List<Object> get props => [];
}

class DonationInitial extends DonationState {}

class DonationLoading extends DonationState {}

class DonationSuccess extends DonationState {
  final String? message;
  final List<DropdownMenuItem<DonationDto>>? donations;
  final bool forDonationOffer;

  const DonationSuccess({
    this.message,
    this.donations,
    this.forDonationOffer = false,
  });

  @override
  List<Object> get props => [message!, donations!];
}

class DonationError extends DonationState {
  final String? errorMessage;

  const DonationError({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}

class DonationAlreadyExistsError implements Exception {
  final String message;

  DonationAlreadyExistsError([this.message = '']);

  @override
  String toString() {
    if (message.isNotEmpty) {
      return 'DonationAlreadyExistsError: $message';
    }
    return 'DonationAlreadyExistsError';
  }
}