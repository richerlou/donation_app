import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/data/models/joined_event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:donation_management/feature/events/presentation/screens/donation_approval_screen.dart';
import 'package:donation_management/feature/events/presentation/widgets/participant_item_tile.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:donation_management/feature/profile/presentation/screens/view_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewParticipantsScreen extends StatelessWidget {
  const ViewParticipantsScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  final ViewParticipantsScreenArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Participants'),
      body: StreamBuilder<QuerySnapshot>(
        stream: context.read<EventCubit>().getParticipants(args.event.eventId!),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            if (snapshot.data!.docs.isNotEmpty) {
              return _buildParticipantsList(snapshot.data!.docs);
            } else {
              return const Center(
                child: CustomEmptyPlaceholder(
                  iconData: Icons.groups,
                  title: 'No participants joined yet.',
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

  Widget _buildParticipantsList(
    List<QueryDocumentSnapshot> joinedEventsSnapshot,
  ) {
    List<JoinedEventDto> _joinedEvents = <JoinedEventDto>[];

    for (QueryDocumentSnapshot element in joinedEventsSnapshot) {
      _joinedEvents.add(
        JoinedEventDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: _joinedEvents.length,
      itemBuilder: (context, index) {
        return FutureBuilder<UserDto>(
          future: context
              .read<ProfileCubit>()
              .getUserData(_joinedEvents[index].joinedBy!),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              UserDto user = snapshot.data!;

              if (snapshot.data != null) {
                return ParticipantItemTile(
                  user: user,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.viewProfileScreen,
                      arguments: ViewProfileScreenArgs(
                        user: user,
                        showEditIcon: false,
                      ),
                    );
                  },
                  icon: Icons.inventory,
                  actionOnPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.donationApprovalScreen,
                      arguments: DonationApprovalScreenArgs(
                        user: user,
                        event: args.event,
                        joinedEventId: _joinedEvents[index].joinedEventId,
                      ),
                    );
                  },
                );
              }
            }

            return const SizedBox.shrink();
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class ViewParticipantsScreenArgs {
  final EventDto event;

  ViewParticipantsScreenArgs({
    required this.event,
  });
}
