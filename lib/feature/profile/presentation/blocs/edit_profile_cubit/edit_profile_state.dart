part of 'edit_profile_cubit.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final bool handleSnackbar;
  final String? profilePhoto;
  final String? profilePhotoName;

  const EditProfileSuccess({
    this.handleSnackbar = false,
    this.profilePhoto,
    this.profilePhotoName,
  });

  @override
  List<Object> get props => [handleSnackbar, profilePhotoName!];
}

class EditProfileError extends EditProfileState {
  final String? errorMessage;
  const EditProfileError({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}
