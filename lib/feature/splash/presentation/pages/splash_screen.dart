import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/core/presentation/blocs/application_cubit/application_cubit.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/feature/home/presentation/screens/home_screen.dart';
import 'package:donation_management/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ApplicationCubit, ApplicationState>(
        listener: (context, state) {
          if (state is UserPersists) {
            context.read<AccountCubit>().loadUser();

            Navigator.pushReplacementNamed(
              context,
              AppRouter.homeScreen,
              arguments: HomeScreenArgs(
                user: state.user,
                userRole: state.user.getUserRole,
              ),
            );
          }

          if (state is UserRevoked) {
            Navigator.pushReplacementNamed(
              context,
              AppRouter.loginScreen,
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.lgBrand.image(height: 100.h),
              SizedBox(height: 50.h),
              SpinKitThreeBounce(color: AppStyle.kPrimaryColor, size: 30.sp),
            ],
          ),
        ),
      ),
    );
  }
}
