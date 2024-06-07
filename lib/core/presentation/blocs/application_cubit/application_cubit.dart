import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:donation_management/core/data/services/firebase_messaging_service.dart';
import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:equatable/equatable.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit(
    this._firebaseService,
    this._securedStorageService,
    this._userRepository,
    this._firebaseMessagingService,
  ) : super(ApplicationInitial());

  final FirebaseService? _firebaseService;
  final SecuredStorageService? _securedStorageService;
  final UserRepositoryImpl? _userRepository;
  final FirebaseMessagingService _firebaseMessagingService;

  Future<void> checkIfUserLoggedIn() async {
    try {
      String? localUser = await _securedStorageService!.readSecureData(
        _securedStorageService!.localUserKey,
      );

      if (_firebaseService?.currentUserStatus.uid != null &&
          localUser != null) {
        String? fcmToken = await _firebaseMessagingService.getFCMToken();

        UserDto user = await _userRepository!.getUser(
          _firebaseService!.currentUserStatus.uid,
        );

        user.fcmToken = fcmToken;
        user.updatedAt = DateTime.now();

        await _userRepository!.updateUser(
          user.userId!,
          updateProfileData: user,
        );

        await _securedStorageService!.writeSecureData(
          _securedStorageService!.localUserKey,
          jsonEncode(user.toJsonWithoutDates()),
        );

        emit(UserPersists(user));
      } else {
        emit(UserRevoked());
      }
    } catch (e) {
      emit(UserRevoked());
    }
  }
}
