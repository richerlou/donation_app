import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._userRepository,
    this._securedStorageService,
  ) : super(ProfileInitial());

  final UserRepositoryImpl _userRepository;
  final SecuredStorageService _securedStorageService;

  Future<void> loadUser() async {
    emit(ProfileLoading());

    try {
      UserDto user = await _userRepository.getUser('9ivChRmbyMMtuRbSEJV0');

      await _securedStorageService.writeSecureData(
        _securedStorageService.localUserKey,
        jsonEncode(user.toJsonWithoutDates()),
      );

      emit(ProfileSuccess(user: user));
    } catch (err) {
      if (err is SocketException) {
        emit(const ProfileError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const ProfileError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  Stream<DocumentSnapshot>? getUserDataStream(String userId) =>
      _userRepository.getUserStream(userId);

  Future<UserDto>? getUserData(String userId) =>
      _userRepository.getUser(userId);
}
