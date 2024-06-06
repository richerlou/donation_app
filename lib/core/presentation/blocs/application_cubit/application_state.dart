part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object> get props => [];
}

class ApplicationInitial extends ApplicationState {}

class ApplicationLoading extends ApplicationState {}

class ApplicationError extends ApplicationState {
  final String? errorMessage;
  const ApplicationError({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}

class UserPersists extends ApplicationState {
  final UserDto user;
  const UserPersists(this.user);

  @override
  List<Object> get props => [user];
}

class UserRevoked extends ApplicationState {}
