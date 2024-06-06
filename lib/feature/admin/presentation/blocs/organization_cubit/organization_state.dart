
part of 'organization_cubit.dart';

abstract class OrganizationState extends Equatable {
  const OrganizationState();

  @override
  List<Object> get props => [];
}

class OrganizationInitial extends OrganizationState {}

class OrganizationLoading extends OrganizationState {}

class OrganizationSuccess extends OrganizationState {
  final List<UserDto>? user;

  const OrganizationSuccess({this.user});

  @override
  List<Object> get props => [user!];
}

class OrganizationSubmitSuccess extends OrganizationState {
  final UserDto? user;

  const OrganizationSubmitSuccess({this.user});

  @override
  List<Object> get props => [user!];
}

class OrganizationError extends OrganizationState {
  final String? errorMessage;

  const OrganizationError({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}
