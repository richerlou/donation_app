import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:donation_management/core/data/services/firebase_messaging_service.dart';
import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/core/domain/authentication_repository.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit(
    this._authenticationRepository,
    this._userRepository,
    this._securedStorageService,
    this._firebaseMessagingService,
  ) : super(RegistrationInitial());

  final AuthenticationRepositoryImpl? _authenticationRepository;
  final UserRepositoryImpl? _userRepository;
  final SecuredStorageService? _securedStorageService;
  final FirebaseMessagingService _firebaseMessagingService;

  Future<void> createAccount(UserRole userRole, FormGroup form) async {
    emit(RegistrationLoading());

    try {
      bool emailAddressExists =
          await _userRepository!.checkIfEmailAddressExists(
        form.control('emailAddress').value,
      );

      if (!emailAddressExists) {
        UserDto? user;
        UserCredential? cred = await _authenticationRepository!.registerUser(
          emailAddress: form.control('emailAddress').value,
          password: form.control('password').value,
        );

        String? fcmToken = await _firebaseMessagingService.getFCMToken();

        if (userRole == UserRole.organization) {
          await _registerOrganization(
            userCredential: cred!,
            form: form,
          );

          await _authenticationRepository.signOut();
        } else {
          user = await _registerIndividual(
            fcmToken: fcmToken,
            userCredential: cred!,
            form: form,
          );
        }

        emit(
          RegistrationSuccess(
            isOrgRegistration: (userRole == UserRole.organization),
            user: user,
          ),
        );
      } else {
        emit(
          const RegistrationError(
            hasEmailError: true,
            errorMessage: 'Email address already exists',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const RegistrationError(
          hasEmailError: false,
          errorMessage: 'The password provided is too weak.',
        ));
      } else if (e.code == 'email-already-in-use') {
        emit(const RegistrationError(
          hasEmailError: false,
          errorMessage: 'The account already exists for that email.',
        ));
      } else {
        emit(const RegistrationError(
          hasEmailError: false,
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    } catch (err) {
      if (err is SocketException) {
        emit(const RegistrationError(
          hasEmailError: false,
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const RegistrationError(
          hasEmailError: false,
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  Future<UserDto> _registerIndividual({
    String? fcmToken,
    required UserCredential userCredential,
    required FormGroup form,
  }) async {
    UserDto data = UserDto(
      userId: userCredential.user!.uid,
      userRole: UserRole.individual.code(),
      firstName: form.control('firstName').value,
      middleName: form.control('middleName').value,
      lastName: form.control('lastName').value,
      barangay: form.control('barangay').value,
      emailAddress: form.control('emailAddress').value,
      mobileNumber: form.control('mobileNumber').value,
      profileDescription: form.control('bio').value,
      fcmToken: fcmToken,
      isApproved: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _userRepository!.storeRegisteredUser(
      userCredential.user!.uid,
      registrationData: data,
    );

    await _securedStorageService!.writeSecureData(
      _securedStorageService.localUserKey,
      jsonEncode(data.toJsonWithoutDates()),
    );

    return data;
  }

  Future<void> _registerOrganization({
    required UserCredential userCredential,
    required FormGroup form,
  }) async {
    UserDto data = UserDto(
      userId: userCredential.user!.uid,
      userRole: UserRole.organization.code(),
      organizationName: form.control('organizationName').value,
      organizationLocation: form.control('location').value,
      organizationType: form.control('organizationType').value,
      organizationWebsite: form.control('website').value,
      organizationRepName1: form.control('organizationRepName1').value,
      organizationRepLocation1: form.control('organizationRepLocation1').value,
      organizationRepMobileNumber1:
          form.control('organizationRepMobileNumber1').value,
      organizationRepName2: _dataOrNull(
        form.control('organizationRepName2').value,
      ),
      organizationRepLocation2: _dataOrNull(
        form.control('organizationRepLocation2').value,
      ),
      organizationRepMobileNumber2: _dataOrNull(
        form.control('organizationRepMobileNumber2').value,
      ),
      emailAddress: form.control('emailAddress').value,
      mobileNumber: form.control('mobileNumber').value,
      profileDescription: form.control('bio').value,
      isApproved: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _userRepository!.storeRegisteredUser(
      userCredential.user!.uid,
      registrationData: data,
    );
  }

  String? _dataOrNull(String? value) {
    if (value != null && value != '') {
      return value;
    } else {
      return 'null';
    }
  }
}
