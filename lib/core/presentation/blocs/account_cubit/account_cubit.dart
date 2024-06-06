// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/core/domain/authentication_repository.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:equatable/equatable.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(
    this._authenticationRepository,
    this._securedStorageService,
  ) : super(AccountInitial());

  final AuthenticationRepositoryImpl? _authenticationRepository;
  final SecuredStorageService? _securedStorageService;

  Future<void> loadUser() async {
    try {
      String? localData = await _securedStorageService!.readSecureData(
        _securedStorageService.localUserKey,
      );

      UserDto user = UserDto.fromJson(jsonDecode(localData!));

      emit(AccountSuccess(user: user));
    } catch (err) {
      emit(const AccountError(errorMessage: 'Oops! Something went wrong.'));
    }
  }

  Future<void> signOut() async {
    emit(AccountLoading());

    try {
      await _authenticationRepository!.signOut();

      await _securedStorageService!.deleteSecureData(
        _securedStorageService.localUserKey,
      );

      emit(const AccountSuccess(forSignOut: true));
    } catch (err) {
      if (err is SocketException) {
        emit(const AccountError(
          forSignOut: true,
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const AccountError(
          forSignOut: true,
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }
}
