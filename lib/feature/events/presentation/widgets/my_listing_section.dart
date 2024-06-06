import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/data/models/joined_event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:donation_management/feature/events/presentation/screens/event_details_screen.dart';
import 'package:donation_management/feature/events/presentation/widgets/event_item_tile.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyListingSection extends StatelessWidget {
  const MyListingSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserDto user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        centerTitle: true,
        title: 'My Listings',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: context.read<EventCubit>().getMyListing(user.userId!),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            if (snapshot.data!.docs.isNotEmpty) {
              return _buildJoinedEventsList(snapshot.data!.docs);
            } else {
              return const Center(
                child: CustomEmptyPlaceholder(
                  iconData: Icons.event,
                  title: 'You don\'t have any joined events yet.',
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

  Widget _buildJoinedEventsList(List<QueryDocumentSnapshot> eventsSnapshot) {
    List<JoinedEventDto> _joinedEventItems = <JoinedEventDto>[];

    for (QueryDocumentSnapshot element in eventsSnapshot) {
      _joinedEventItems.add(
        JoinedEventDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: _joinedEventItems.length,
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
            child: FutureBuilder<EventDto>(
              future: context.read<EventCubit>().getEventDataFuture(
                    _joinedEventItems[index].joinedEventId!,
                  ),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  if (snapshot.data != null) {
                    return EventItemTile(
                      event: snapshot.data!,
                      onItemPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(
                              args: EventDetailsScreenArgs(
                                event: snapshot.data!,
                                senderUser: user,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }

                return const CustomProgressIndicator();
              },
            ),
          ),
        );
      },
    );
  }
}
