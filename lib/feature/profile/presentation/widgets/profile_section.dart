import 'package:donation_management/core/data/mixins/account_mixin.dart';
import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_avatar.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/feature/profile/presentation/screens/view_profile_screen.dart';
import 'package:donation_management/feature/profile/presentation/widgets/custom_settings_tile.dart';
import 'package:donation_management/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> with AccountMixin {
  @override
  void initState() {
    context.read<AccountCubit>().loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: BlocConsumer<AccountCubit, AccountState>(
        buildWhen: (previous, current) {
          if (current is AccountLoading || current is AccountSuccess) {
            if (current is AccountSuccess) {
              if (current.forSignOut) {
                return false;
              } else {
                return true;
              }
            }

            return false;
          }

          return true;
        },
        listener: (context, state) {
          if (state is AccountLoading) {
            CustomLoader.of(context).show();
          }

          if (state is AccountSuccess) {
            if (state.forSignOut) {
              CustomLoader.of(context).managePop(true);
              CustomLoader.of(context).hide();

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.loginScreen,
                (route) => false,
              );
            }
          }

          if (state is AccountError) {
            SnackbarUtils.removeCurrentSnackbar(context: context);

            if (state.forSignOut) {
              CustomLoader.of(context).managePop(true);
              CustomLoader.of(context).hide();
            }

            SnackbarUtils.showSnackbar(
              context: context,
              title: state.errorMessage!,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                _buildProfileHeader(state),
                _buildProfileSettingsContainer(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AccountState state) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      color: const Color(0xFFF9F9F9),
      padding: EdgeInsets.all(25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi there,',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: FontFamily.dMSans,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF191919),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                '${buildProfileName(state)}.',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: FontFamily.dMSans,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF191919),
                ),
              ),
            ],
          ),
          CustomAvatar(
            heroTag: 'profilePhoto',
            name: buildProfileName(state),
            networkAsset: buildProfilePicture(state),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSettingsContainer(
    BuildContext context,
    AccountState state,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        elevation: 20.0,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          width: double.infinity,
          padding: EdgeInsets.only(top: 33.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSettingsTile(
                title: 'View Profile',
                suffixIconData: Icons.person,
                settingsOnTapped: () {
                  AccountSuccess tmpState = state as AccountSuccess;

                  Navigator.pushNamed(
                    context,
                    AppRouter.viewProfileScreen,
                    arguments: ViewProfileScreenArgs(
                      user: tmpState.user!,
                    ),
                  );
                },
              ),
              CustomSettingsTile(
                title: 'Change password',
                suffixIconData: Icons.lock,
                settingsOnTapped: () => Navigator.pushNamed(
                  context,
                  AppRouter.changePasswordScreen,
                ),
              ),
              CustomSettingsTile(
                title: 'Sign out',
                titleColor: Colors.red,
                suffixIconData: Icons.logout,
                suffixIconColor: Colors.red,
                showDivider: false,
                settingsOnTapped: () {
                  DialogUtils.showConfirmationDialog(
                    context,
                    title: 'Confirmation',
                    content: 'Are you sure you want to sign out?',
                    onPrimaryButtonPressed: () async {
                      Navigator.pop(context);

                      await context.read<AccountCubit>().signOut();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
