import 'package:donation_management/feature/profile/presentation/blocs/edit_profile_cubit/edit_profile_cubit.dart';

mixin ProfileMixin {
  String buildFullName({
    required String firstName,
    String? middleName,
    required String lastName,
  }) {
    String fullName = '...';

    if (middleName != null) {
      fullName = '$firstName $middleName $lastName';
    } else {
      fullName = '$firstName $lastName';
    }

    return fullName;
  }

  String buildGender(int gender) {
    String genderText = 'Rather not say';

    if (gender == 1) {
      genderText = 'Male';
    } else if (gender == 2) {
      genderText = 'Female';
    }

    return genderText;
  }

  String buildMiddleName(String? middleName) {
    String middleNameText = 'None';

    if (middleName != null && middleName != '') {
      middleNameText = middleName;
    }

    return middleNameText;
  }

  String buildMobileNumber(String? mobileNumber) {
    String mobileNumberText = 'None';

    if (mobileNumber != null && mobileNumber != '') {
      mobileNumberText = '0$mobileNumber';
    }

    return mobileNumberText;
  }

  String? buildProfilePicture(EditProfileState state) {
    if (state is EditProfileSuccess) {
      if (state.profilePhoto != null) {
        return state.profilePhoto!;
      }
    }

    return null;
  }

  String buildProfileName(EditProfileState state) {
    String name = '...';

    if (state is EditProfileSuccess) {
      if (state.profilePhotoName != null) {
        name = state.profilePhotoName!;
      }
    }

    return name;
  }
}
