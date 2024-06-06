import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:donation_management/core/domain/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit(
    this._authenticationRepository,
  ) : super(PasswordInitial());

  final AuthenticationRepositoryImpl _authenticationRepository;

  Future<void> changePassword(FormGroup form) async {
    emit(ChangePasswordLoading());

    try {
      await _authenticationRepository.checkCurrentPassword(
        form.control('oldPassword').value,
      );

      await _authenticationRepository.changePassword(
        form.control('newPassword').value,
      );

      emit(ChangePasswordSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const ChangePasswordError(
          hasCurrentPasswordError: false,
          errorMessage: 'The password provided is too weak.',
        ));
      } else if (e.code == 'wrong-password') {
        emit(const ChangePasswordError(
          hasCurrentPasswordError: true,
          errorMessage: 'Current password is invalid',
        ));
      } else {
        emit(const ChangePasswordError(
          hasCurrentPasswordError: false,
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    } catch (err) {
      if (err is SocketException) {
        emit(const ChangePasswordError(
          hasCurrentPasswordError: false,
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const ChangePasswordError(
          hasCurrentPasswordError: false,
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }
}
