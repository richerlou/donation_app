part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserDto user;
  const LoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class LoginError extends LoginState {
  final String? errorMessage;
  const LoginError({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}
