import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/feature/events/data/enums/event_type.dart';
import 'package:donation_management/feature/events/presentation/screens/add_edit_event_screen.dart';
import 'package:donation_management/feature/events/presentation/widgets/event_tab.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';

class PostingSection extends StatelessWidget {
  const PostingSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserDto user;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'My Postings',
            style: AppStyle.kStyleBold.copyWith(
              fontSize: 22.0,
              color: AppStyle.kColorWhite,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppStyle.kColorWhite,
            labelStyle: AppStyle.kStyleBold.copyWith(
              color: Colors.white,
            ),
            tabs: [
              Tab(text: EventType.donationDrive.text()),
              Tab(text: EventType.volunteer.text()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EventTab(
              postedBy: user.userId!,
              eventType: EventType.donationDrive,
              isOrganization: true,
            ),
            EventTab(
              postedBy: user.userId!,
              eventType: EventType.volunteer,
              isOrganization: true,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRouter.addEditEventScreen,
              arguments: AddEditEventScreenArgs(),
            );
          },
          child: const Icon(Icons.post_add),
        ),
      ),
    );
  }
}
