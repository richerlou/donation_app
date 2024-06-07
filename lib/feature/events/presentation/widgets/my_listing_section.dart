import 'package:donation_management/core/presentation/utils/app_style.dart';

import 'package:donation_management/feature/events/data/enums/event_status.dart';
import 'package:donation_management/feature/events/presentation/widgets/my_listing_tab.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';

class MyListingSection extends StatelessWidget {
  const MyListingSection({
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
            'My Listings',
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
            MyListingTab(
              user: user,
              eventStatus: EventStatus.notYetStarted,
            ),
            MyListingTab(
              user: user,
              eventStatus: EventStatus.onGoing,
            ),
            MyListingTab(
              user: user,
              eventStatus: EventStatus.rescheduled,
            ),
            MyListingTab(
              user: user,
              eventStatus: EventStatus.completed,
            ),
            MyListingTab(
              user: user,
              eventStatus: EventStatus.cancelled,
            ),
          ],
        ),
      ),
    );
  }
}
