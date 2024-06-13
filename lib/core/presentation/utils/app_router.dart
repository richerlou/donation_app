import 'package:donation_management/feature/authentication/login/presentation/pages/login_screen.dart';
import 'package:donation_management/feature/authentication/registration/presentation/pages/registration_screen.dart';
import 'package:donation_management/feature/authentication/registration/presentation/pages/user_checker_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/add_edit_donation_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/add_edit_event_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/donation_approval_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/donation_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/give_donation_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/view_participants_screen.dart';
import 'package:donation_management/feature/home/presentation/screens/home_screen.dart';
import 'package:donation_management/feature/profile/presentation/screens/change_password_screen.dart';
import 'package:donation_management/feature/profile/presentation/screens/edit_profile_screen.dart';
import 'package:donation_management/feature/profile/presentation/screens/view_profile_screen.dart';
import 'package:donation_management/feature/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String splashScreen = '/';
  static const String loginScreen = '/loginScreen';
  static const String userCheckerScreen = '/userCheckerScreen';
  static const String registrationScreen = '/registrationScreen';
  static const String homeScreen = '/homeScreen';
  static const String viewProfileScreen = '/viewProfileScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String addEditEventScreen = '/addEditEventScreen';
  static const String viewParticipantsScreen = '/viewParticipantsScreen';
  static const String donationScreen = '/donationScreen';
  static const String addEditDonationScreen = '/addEditDonationScreen';
  static const String donationApprovalScreen = '/donationApprovalScreen';
  static const String giveDonationScreen = '/giveDonationScreen';
  // static const String approvedDonationsScreen = '/approvedDonationsScreen';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Object? arguments = settings.arguments;

    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
        );
      case loginScreen:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        );
      case userCheckerScreen:
        return MaterialPageRoute<void>(
          builder: (_) => const UserCheckerScreen(),
        );
      case registrationScreen:
        return MaterialPageRoute<void>(
          builder: (_) => RegistrationScreen(
            args: arguments as RegistrationScreenArgs,
          ),
        );
      case homeScreen:
        return MaterialPageRoute<void>(
          builder: (_) => HomeScreen(
            args: arguments as HomeScreenArgs,
          ),
        );
      case viewProfileScreen:
        return MaterialPageRoute<void>(
          builder: (_) => ViewProfileScreen(
            args: arguments as ViewProfileScreenArgs,
          ),
        );
      case changePasswordScreen:
        return MaterialPageRoute<void>(
          builder: (_) => const ChangePasswordScreen(),
        );
      case editProfileScreen:
        return MaterialPageRoute<void>(
          builder: (_) => EditProfileScreen(
            args: arguments as EditProfileScreenArgs,
          ),
        );
      case addEditEventScreen:
        return MaterialPageRoute<void>(
          builder: (_) => AddEditEventScreen(
            args: arguments as AddEditEventScreenArgs,
          ),
        );
      case viewParticipantsScreen:
        return MaterialPageRoute<void>(
          builder: (_) => ViewParticipantsScreen(
            args: arguments as ViewParticipantsScreenArgs,
          ),
        );
      case donationScreen:
        return MaterialPageRoute<void>(
          builder: (_) => DonationScreen(
            args: arguments as DonationScreenArgs,
          ),
        );
      case addEditDonationScreen:
        return MaterialPageRoute<void>(
          builder: (_) => AddEditDonationScreen(
            args: arguments as AddEditDonationScreenArgs,
          ),
        );
      case donationApprovalScreen:
        return MaterialPageRoute<void>(
          builder: (_) => DonationApprovalScreen(
            args: arguments as DonationApprovalScreenArgs,
          ),
        );
      case giveDonationScreen:
        return MaterialPageRoute<void>(
          builder: (_) => GiveDonationScreen(
            args: arguments as GiveDonationScreenArgs,
          ),
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
