part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserDto? user;

  const ProfileSuccess({this.user});

  @override
  List<Object> get props => [user!];
}

class ProfileError extends ProfileState {
  final String? errorMessage;

  const ProfileError({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}
