// c:/Users/admin/Documents/donation_management/lib/feature/home/presentation/screens/admin_home_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/admin/presentation/blocs/organization_cubit/organization_cubit.dart';
import 'package:flutter/material.dart';
import 'package:donation_management/feature/admin/presentation/widgets/orgs_pending.dart';
import 'package:donation_management/feature/admin/presentation/widgets/orgs_approved.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, required this.args});

  final AdminHomeScreenArgs args;

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Admin Home'),
    //     bottom: TabBar(
    //       controller: _tabController,
    //       tabs: const [
    //         Tab(text: 'Approved'),
    //         Tab(text: 'Needs Approval'),
    //       ],
    //     ),
    //   ),
    //   body: TabBarView(
    //     controller: _tabController,
    //     children: [
    //       OrgsApproved(),
    //       OrgsPending(),
    //     ],
    //   ),
    // );
    return Scaffold(
      appBar: CustomAppBar(
        title: 'OrganizationsZ',
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Approved'),
            Tab(text: 'Needs Approval'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: context.read<OrganizationCubit>().getOrganizations(),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            if (snapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot> eventsSnapshot = snapshot.data!.docs;
              List<UserDto> userItems = <UserDto>[];
              for (QueryDocumentSnapshot element in eventsSnapshot) {
                userItems.add(
                  UserDto.fromJson(element.data() as Map<String, dynamic>),
                );
              }
              return TabBarView(
                controller: _tabController,
                children: [
                  OrgsApproved(organizations: userItems),
                  OrgsPending(organizations: userItems),
                ],
              );
            } else {
              return const Center(
                child: CustomEmptyPlaceholder(
                  iconData: Icons.event_busy,
                  title: 'No Organization yet',
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: CustomEmptyPlaceholder(
                iconData: Icons.warning,
                title: 'Oops! Something went wrong.',
                buttonWidth: 150.0,
                buttonTitle: 'Retry',
                buttonOnPressed: () {},
              ),
            );
          }

          return const CustomProgressIndicator();
        },
      ),
    );
  }
}

class OrganizationList extends StatelessWidget {
  final String status;

  const OrganizationList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // Fetch organizations based on status
    // This is a placeholder for the actual data fetching logic
    final organizations = [
      UserDto(organizationName: 'Org 1', isApproved: status == 'approved'),
      UserDto(organizationName: 'Org 2', isApproved: status == 'approved'),
    ];

    return ListView.builder(
      itemCount: organizations.length,
      itemBuilder: (context, index) {
        final org = organizations[index];
        return ListTile(
          title: Text(org.organizationName ?? 'Unknown'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OrganizationDetailScreen(organization: org),
              ),
            );
          },
        );
      },
    );
  }
}

class OrganizationDetailScreen extends StatelessWidget {
  final UserDto organization;

  const OrganizationDetailScreen({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(organization.organizationName ?? 'Organization Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Organization Name: ${organization.organizationName}'),
            Text('Email: ${organization.emailAddress}'),
            Text('Mobile: ${organization.mobileNumber}'),
            Text('Description: ${organization.profileDescription}'),
            const Spacer(),
            if (!organization.isApproved!)
              CustomButton(
                  buttonTitle: "Approve",
                  onPressed: () {
                    DialogUtils.showConfirmationDialog(
                      context,
                      title: 'Confirmation',
                      content:
                          'Are you sure you want to approve this organization?',
                      onPrimaryButtonPressed: () async {
                        Navigator.pop(context);

                        UserDto userDto = organization;
                        userDto = userDto.copyWith(isApproved: true);
                        await context
                            .read<OrganizationCubit>()
                            .approveOrganization(data: userDto);
                      },
                    );
                  })
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}

class AdminHomeScreenArgs {
  final UserDto user;

  AdminHomeScreenArgs({required this.user});
}
