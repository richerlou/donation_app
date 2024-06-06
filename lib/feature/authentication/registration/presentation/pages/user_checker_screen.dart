import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/feature/authentication/registration/presentation/pages/registration_screen.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCheckerScreen extends StatelessWidget {
  const UserCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Choose your account type'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 23.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              buttonTitle: 'Individual',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.registrationScreen,
                  arguments: RegistrationScreenArgs(),
                );
              },
            ),
            SizedBox(height: 15.h),
            CustomButton(
              buttonTitle: 'Organization',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.registrationScreen,
                  arguments: RegistrationScreenArgs(
                    userRole: UserRole.organization,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
