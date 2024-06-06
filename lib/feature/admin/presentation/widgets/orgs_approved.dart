// c:/Users/admin/Documents/donation_management/lib/feature/home/presentation/screens/orgs_approved.dart

import 'package:flutter/material.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/admin/presentation/screens/admin_home_screen.dart';

class OrgsApproved extends StatelessWidget {
  final List<UserDto> organizations;

  const OrgsApproved({super.key, required this.organizations});

  @override
  Widget build(BuildContext context) {
    // Fetch approved organizations
    // final organizations = [
    //   UserDto(organizationName: 'Approved Org 1', isApproved: true),
    //   UserDto(organizationName: 'Approved Org 2', isApproved: true),
    // ];

    return ListView.builder(
      itemCount: organizations.length,
      itemBuilder: (context, index) {
        final org = organizations[index];
        if(org.isApproved == false) return Container();

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
