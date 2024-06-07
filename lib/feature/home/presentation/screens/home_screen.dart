import 'package:donation_management/core/data/services/firebase_messaging_service.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/feature/events/presentation/widgets/events_section.dart';
import 'package:donation_management/feature/events/presentation/widgets/my_listing_section.dart';
import 'package:donation_management/feature/events/presentation/widgets/posting_section.dart';
import 'package:donation_management/feature/messages/presentation/widgets/messages_section.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:donation_management/feature/admin/presentation/screens/admin_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.args,
  });

  final HomeScreenArgs args;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _currentIndex;
  List<BottomNavigationBarItem>? _tabItems;
  List<Widget>? _screens;

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  void _buildIndividualScreens() {
    _screens = [
      EventsSection(user: widget.args.user!),
      MyListingSection(user: widget.args.user!),
      MessagesSection(user: widget.args.user!),
      const ProfileSection(),
    ];

    _tabItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: 'My Listings',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: 'Messages',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  void _buildOrganizationScreens() {
    _screens = [
      PostingSection(user: widget.args.user!),
      MessagesSection(user: widget.args.user!),
      const ProfileSection(),
    ];

    _tabItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: 'Messages',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  void _buildAdminScreens() {
    _screens = [
      AdminHomeScreen(args: AdminHomeScreenArgs(user: widget.args.user!)),
      const ProfileSection(),
    ];

    _tabItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        label: 'Organizations',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  @override
  void initState() {
    FirebaseMessagingService.onBackgroundHandler();

    FirebaseMessagingService.onForegroundHandler();

    _currentIndex = 0;

    if (widget.args.userRole!.code() == UserRole.individual.code()) {
      _buildIndividualScreens();
    } else if (widget.args.userRole!.code() == UserRole.organization.code()) {
      _buildOrganizationScreens();
    } else if (widget.args.userRole!.code() == UserRole.admin.code()) {
      _buildAdminScreens();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _screens![_currentIndex!],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex!,
        onTap: _onTabTapped,
        selectedLabelStyle: AppStyle.kStyleMedium,
        unselectedLabelStyle: AppStyle.kStyleMedium,
        items: _tabItems!,
      ),
    );
  }
}

class HomeScreenArgs {
  final int? tabIndex;
  final UserDto? user;
  final UserRole? userRole;

  HomeScreenArgs({
    this.tabIndex,
    this.user,
    this.userRole,
  });
}
