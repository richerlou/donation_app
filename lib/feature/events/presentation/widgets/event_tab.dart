import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/events/data/enums/event_type.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:donation_management/feature/events/presentation/screens/event_details_screen.dart';
import 'package:donation_management/feature/events/presentation/widgets/event_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventTab extends StatelessWidget {
  const EventTab({
    super.key,
    required this.postedBy,
    required this.eventType,
    this.isOrganization = false,
  });

  final String postedBy;
  final EventType eventType;
  final bool isOrganization;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context
          .read<EventCubit>()
          .getPostedEvent(postedBy: postedBy, eventType: eventType),
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          if (snapshot.data!.docs.isNotEmpty) {
            return _buildEventsList(snapshot.data!.docs);
          } else {
            return const Center(
              child: CustomEmptyPlaceholder(
                iconData: Icons.post_add,
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
    );
  }

  Widget _buildEventsList(List<QueryDocumentSnapshot> eventsSnapshot) {
    List<EventDto> _eventItems = <EventDto>[];

    for (QueryDocumentSnapshot element in eventsSnapshot) {
      _eventItems.add(
        EventDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

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
                        isOrganization: isOrganization,
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
