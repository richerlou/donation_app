part of 'password_cubit.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];
}

class PasswordInitial extends PasswordState {}

class ChangePasswordLoading extends PasswordState {}

class ChangePasswordSuccess extends PasswordState {}

class ChangePasswordError extends PasswordState {
  final String? errorMessage;
  final bool? hasCurrentPasswordError;

  const ChangePasswordError({
    this.hasCurrentPasswordError,
    this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage!, hasCurrentPasswordError!];
}
