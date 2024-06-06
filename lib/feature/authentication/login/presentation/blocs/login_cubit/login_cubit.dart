import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/core/domain/authentication_repository.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this._authenticationRepository,
    this._userRepository,
    this._securedStorageService,
  ) : super(LoginInitial());

  final AuthenticationRepositoryImpl? _authenticationRepository;
  final UserRepositoryImpl? _userRepository;
  final SecuredStorageService? _securedStorageService;

  Future<void> loginAccount({
    required String emailAddress,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      UserCredential? userCredential = await _authenticationRepository!.login(
        email: emailAddress,
        password: password,
      );

      UserDto user = await _userRepository!.getUser(userCredential!.user!.uid);

      if (user.isApproved!) {
        await _securedStorageService!.writeSecureData(
          _securedStorageService.localUserKey,
          jsonEncode(user.toJsonWithoutDates()),
        );

        emit(LoginSuccess(user));
      } else {
        emit(const LoginError(
          errorMessage:
              'Yikes! It seems your account is not yet approved. Please wait for our admin to approve your account.',
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const LoginError(
          errorMessage: 'No user found for that email.',
        ));
      } else if (e.code == 'wrong-password') {
        emit(const LoginError(
          errorMessage: 'Wrong password provided for that user.',
        ));
      } else {
        emit(const LoginError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    } catch (err) {
      if (err is SocketException) {
        emit(const LoginError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const LoginError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }
}
