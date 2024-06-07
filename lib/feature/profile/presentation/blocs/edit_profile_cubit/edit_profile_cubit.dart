import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/data/mixins/form_mixin.dart';
import 'package:donation_management/core/data/mixins/local_user_mixin.dart';
import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState>
    with LocalUserMixin, FormMixin {
  EditProfileCubit(
    this._userRepository,
    this._securedStorageService,
  ) : super(EditProfileInitial());

  final UserRepositoryImpl _userRepository;
  final SecuredStorageService _securedStorageService;

  Future<void> populateUserData(FormGroup editProfileForm) async {
    UserDto user = await loadLocalUser();

    editProfileForm.reset(
      value: {
        'firstName': user.firstName,
        'middleName': user.middleName,
        'lastName': user.lastName,
        'barangay': user.barangay,
        'organizationName': user.organizationName,
        'location': user.organizationLocation,
        'organizationType': user.organizationType,
        'website': user.organizationWebsite,
        'bio': user.profileDescription,
        'emailAddress': user.emailAddress,
        'mobileNumber': user.mobileNumber,
        'organizationRepName1': user.organizationRepName1,
        'organizationRepLocation1': user.organizationRepLocation1,
        'organizationRepMobileNumber1': user.organizationRepMobileNumber1,
        'organizationRepName2': (user.organizationRepName2 != 'null')
            ? user.organizationRepName2
            : null,
        'organizationRepLocation2': (user.organizationRepLocation2 != 'null')
            ? user.organizationRepLocation2
            : null,
        'organizationRepMobileNumber2':
            (user.organizationRepMobileNumber2 != 'null')
                ? user.organizationRepMobileNumber2
                : null,
      },
    );

    editProfileForm.control('emailAddress').markAsDisabled();

    emit(EditProfileSuccess(
      profilePhotoName: (user.getUserRole == UserRole.individual)
          ? user.firstName
          : user.organizationName,
      profilePhoto: (user.profileImage != null) ? user.profileImage! : null,
    ));
  }

  Future<void> updateProfile({
    required FormGroup form,
    XFile? profilePhoto,
  }) async {
    emit(EditProfileLoading());

    try {
      UserDto user = await loadLocalUser();
      String? profileImage;
      UserDto? updateProfileData;

      if (profilePhoto != null) {
        profileImage = await _userRepository.updateProfilePhoto(
          userId: user.userId!,
          uploadedFile: profilePhoto.path,
        );
      } else {
        profileImage = user.profileImage;
      }

      if (user.getUserRole == UserRole.organization) {
        updateProfileData = _getOrganizationData(
          user: user,
          form: form,
          profileImage: profileImage,
        );
      } else {
        updateProfileData = _getIndividualData(
          user: user,
          form: form,
          profileImage: profileImage,
        );
      }

      await _userRepository.updateUser(
        user.userId!,
        updateProfileData: updateProfileData,
      );

      await _securedStorageService.writeSecureData(
        _securedStorageService.localUserKey,
        jsonEncode(updateProfileData.toJsonWithoutDates()),
      );

      String firstName = (user.getUserRole == UserRole.organization)
          ? form.control('organizationName').value
          : form.control('firstName').value;

      emit(EditProfileSuccess(
        handleSnackbar: true,
        profilePhoto: profileImage,
        profilePhotoName: firstName,
      ));
    } catch (err) {
      if (err is SocketException) {
        emit(const EditProfileError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const EditProfileError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }

  UserDto _getIndividualData({
    required UserDto user,
    required String? profileImage,
    required FormGroup form,
  }) {
    return UserDto(
      userId: user.userId!,
      userRole: user.getUserRole.code(),
      profileImage: profileImage,
      isApproved: user.isApproved,
      firstName: textFieldChecker(
        form.control('firstName').value,
      ),
      middleName: textFieldChecker(
        form.control('middleName').value,
      ),
      lastName: textFieldChecker(
        form.control('lastName').value,
      ),
      barangay: textFieldChecker(
        form.control('barangay').value,
      ),
      profileDescription: form.control('bio').value,
      emailAddress: textFieldChecker(
        form.control('emailAddress').value,
      ),
      mobileNumber: textFieldChecker(
        form.control('mobileNumber').value,
      ),
      updatedAt: DateTime.now(),
    );
  }

  UserDto _getOrganizationData({
    required UserDto user,
    required String? profileImage,
    required FormGroup form,
  }) {
    return UserDto(
      userId: user.userId!,
      userRole: user.getUserRole.code(),
      profileImage: profileImage,
      isApproved: user.isApproved,
      organizationName: textFieldChecker(
        form.control('organizationName').value,
      ),
      organizationLocation: textFieldChecker(
        form.control('location').value,
      ),
      organizationType: textFieldChecker(
        form.control('organizationType').value,
      ),
      organizationWebsite: textFieldChecker(
        form.control('website').value,
      ),
      profileDescription: form.control('bio').value,
      emailAddress: textFieldChecker(
        form.control('emailAddress').value,
      ),
      mobileNumber: textFieldChecker(
        form.control('mobileNumber').value,
      ),
      organizationRepName1: textFieldChecker(
        form.control('organizationRepName1').value,
      ),
      organizationRepLocation1: textFieldChecker(
        form.control('organizationRepLocation1').value,
      ),
      organizationRepMobileNumber1: textFieldChecker(
        form.control('organizationRepMobileNumber1').value,
      ),
      organizationRepName2: _dataOrNull(
        form.control('organizationRepName2').value,
      ),
      organizationRepLocation2: _dataOrNull(
        form.control('organizationRepLocation2').value,
      ),
      organizationRepMobileNumber2: _dataOrNull(
        form.control('organizationRepMobileNumber2').value,
      ),
      updatedAt: DateTime.now(),
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
