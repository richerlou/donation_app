import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/feature/profile/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:donation_management/core/presentation/widgets/custom_network_image.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/profile/data/mixins/profile_mixin.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/screens/edit_profile_screen.dart';
import 'package:donation_management/feature/profile/presentation/widgets/custom_profile_text.dart';
import 'package:donation_management/core/presentation/widgets/custom_floating_button.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewProfileScreen extends StatelessWidget with ProfileMixin {
  const ViewProfileScreen({
    super.key,
    required this.args,
  });

  final ViewProfileScreenArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.kPrimaryColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            context.read<ProfileCubit>().getUserDataStream(args.user.userId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDto user = UserDto.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );

            return Stack(
              children: [
                _buildProfileHeader(context, user),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    elevation: 20.0,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppStyle.kColorWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 56.0,
                          left: 27.0,
                          right: 27.0,
                        ),
                        child: _buildProfileData(context, user),
                      ),
                    ),
                  ),
                ),
                _buildFloatingButtons(context),
              ],
            );
          }

          return const CustomProgressIndicator();
        },
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Positioned(
      top: 45.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomFloatingButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            (args.showEditIcon)
                ? CustomFloatingButton(
                    icon: Icons.edit,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.editProfileScreen,
                        arguments: EditProfileScreenArgs(
                          user: args.user,
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserDto user) {
    String? profileImage = user.profileImage;
    String? firstName = (user.getUserRole == UserRole.individual)
        ? user.firstName
        : user.organizationName;

    Widget widget = const SizedBox.shrink();
    if (profileImage != null) {
      widget = SizedBox(
        height: MediaQuery.of(context).size.height * 0.50,
        width: double.infinity,
        child: CustomNetworkImage(imageUrl: profileImage),
      );
    } else {
      widget = Container(
        color: AppStyle.kColorGreen,
        height: MediaQuery.of(context).size.height * 0.40,
        width: double.infinity,
        child: Center(
          child: Text(
            firstName![0],
            style: AppStyle.kStyleExtraBold.copyWith(
              color: AppStyle.kColorWhite,
              fontSize: 100.0,
            ),
          ),
        ),
      );
    }

    return widget;
  }

  Widget _buildProfileData(BuildContext context, UserDto user) {
    Widget widget = const SizedBox.shrink();

    widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (user.getUserRole == UserRole.individual)
              ? buildFullName(
                  firstName: user.firstName!,
                  middleName:
                      (user.middleName != null) ? user.middleName! : null,
                  lastName: user.lastName!,
                )
              : user.organizationName!,
          style: AppStyle.kStyleBold.copyWith(
            fontSize: 24.0,
          ),
        ),
        const SizedBox(height: 24.0),
        CustomProfileText(
          label: 'Short Bio',
          data: user.profileDescription!,
        ),
        CustomProfileText(
          label: 'Email Address',
          data: user.emailAddress!,
        ),
        CustomProfileText(
          label: 'Mobile Number',
          data: buildMobileNumber(user.mobileNumber!),
        ),
      ],
    );

    return widget;
  }
}

class ViewProfileScreenArgs {
  final UserDto user;
  final bool showEditIcon;

  const ViewProfileScreenArgs({
    required this.user,
    this.showEditIcon = true,
  });
}
