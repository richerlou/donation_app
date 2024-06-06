// c:/Users/admin/Documents/donation_management/lib/feature/home/presentation/screens/orgs_pending.dart

import 'package:donation_management/feature/admin/presentation/screens/admin_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';

class OrgsPending extends StatelessWidget {
  final List<UserDto> organizations;

  const OrgsPending({super.key, required this.organizations});

  @override
  Widget build(BuildContext context) {
    // Fetch pending organizations
    // final organizations = [
    //   UserDto(organizationName: 'Pending Org 1', isApproved: false),
    //   UserDto(organizationName: 'Pending Org 2', isApproved: false),
    // ];

    return ListView.builder(
      itemCount: organizations.length,
      itemBuilder: (context, index) {
        final org = organizations[index];
        if(org.isApproved == true) return Container();

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
