// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:equatable/equatable.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit(
    this._firebaseService,
    this._securedStorageService,
  ) : super(ApplicationInitial());

  final FirebaseService? _firebaseService;
  final SecuredStorageService? _securedStorageService;

  Future<void> checkIfUserLoggedIn() async {
    try {
      String? localUser = await _securedStorageService!.readSecureData(
        _securedStorageService.localUserKey,
      );

      if (_firebaseService?.currentUserStatus.uid != null &&
          localUser != null) {
        UserDto user = UserDto.fromJson(jsonDecode(localUser));

        emit(UserPersists(user));
      } else {
        emit(UserRevoked());
      }
    } catch (e) {
      emit(UserRevoked());
    }
  }
}
