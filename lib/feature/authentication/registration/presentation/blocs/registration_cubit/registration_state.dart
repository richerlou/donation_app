part of 'registration_cubit.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final bool isOrgRegistration;
  final UserDto? user;

  const RegistrationSuccess({
    this.isOrgRegistration = false,
    this.user,
  });

  @override
  List<Object> get props => [isOrgRegistration, user!];
}

class RegistrationError extends RegistrationState {
  final String? errorMessage;
  final bool? hasEmailError;
  const RegistrationError({this.hasEmailError, this.errorMessage});

  @override
  List<Object> get props => [errorMessage!, hasEmailError!];
}
