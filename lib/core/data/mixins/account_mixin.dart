import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/blocs/edit_profile_cubit/edit_profile_cubit.dart';

mixin AccountMixin {
  String buildProfileName(dynamic state) {
    String name = '...';

    if (state is AccountState) {
      if (state is AccountSuccess) {
        if (state.user != null) {
          if (state.user!.getUserRole == UserRole.organization) {
            name = state.user!.organizationName ?? '...';
          } else {
            name = state.user!.firstName ?? '...';
          }
        }
      }
    } else if (state is EditProfileState) {
      if (state is EditProfileSuccess) {
        name = state.profilePhotoName ?? '...';
      }
    }

    return name;
  }

  String? buildProfilePicture(dynamic state) {
    if (state is AccountState) {
      if (state is AccountSuccess) {
        UserDto? user = state.user;
        if (user?.profileImage != null) {
          return user?.profileImage;
        }
      }
    } else if (state is EditProfileState) {
      if (state is EditProfileSuccess) {
        String? profileImage = state.profilePhoto;
        if (profileImage != null) {
          return profileImage;
        }
      }
    }

    return null;
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
}
