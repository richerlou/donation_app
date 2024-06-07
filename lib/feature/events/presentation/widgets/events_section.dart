import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:donation_management/feature/events/presentation/screens/event_details_screen.dart';
import 'package:donation_management/feature/events/presentation/widgets/event_item_tile.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserDto user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Events',
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: context.read<EventCubit>().getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            if (snapshot.data!.docs.isNotEmpty) {
              return _buildEventsList(snapshot.data!.docs);
            } else {
              return const Center(
                child: CustomEmptyPlaceholder(
                  iconData: Icons.event_busy,
                  title: 'No events posted',
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

  Widget _buildEventsList(List<QueryDocumentSnapshot> eventsSnapshot) {
    List<EventDto> _eventItems = <EventDto>[];

    for (QueryDocumentSnapshot element in eventsSnapshot) {
      _eventItems.add(
        EventDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

    _eventItems.sort((b, a) => a.createdAt!.compareTo(b.createdAt!));

    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: _eventItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: AppStyle.kColorWhite,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: EventItemTile(
              event: _eventItems[index],
              onItemPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(
                      args: EventDetailsScreenArgs(
                        event: _eventItems[index],
                        senderUser: user,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
