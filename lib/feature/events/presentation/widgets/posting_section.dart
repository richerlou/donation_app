import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/feature/events/data/enums/event_status.dart';
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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Donation Drive',
            style: AppStyle.kStyleBold.copyWith(
              fontSize: 22.0,
              color: AppStyle.kColorWhite,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelStyle: AppStyle.kStyleMedium,
            tabs: [
              Tab(text: EventStatus.notYetStarted.text()),
              Tab(text: EventStatus.onGoing.text()),
              Tab(text: EventStatus.rescheduled.text()),
              Tab(text: EventStatus.completed.text()),
              Tab(text: EventStatus.cancelled.text()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EventTab(
              postedBy: user.userId!,
              eventType: EventType.donationDrive,
              eventStatus: EventStatus.notYetStarted,
              isOrganization: true,
            ),
            EventTab(
              postedBy: user.userId!,
              eventType: EventType.donationDrive,
              eventStatus: EventStatus.onGoing,
              isOrganization: true,
            ),
            EventTab(
              postedBy: user.userId!,
              eventType: EventType.donationDrive,
              eventStatus: EventStatus.rescheduled,
              isOrganization: true,
            ),
            EventTab(
              postedBy: user.userId!,
              eventType: EventType.donationDrive,
              eventStatus: EventStatus.completed,
              isOrganization: true,
            ),
            EventTab(
              postedBy: user.userId!,
              eventType: EventType.donationDrive,
              eventStatus: EventStatus.cancelled,
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
