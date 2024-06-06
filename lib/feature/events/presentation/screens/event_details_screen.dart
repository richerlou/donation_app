import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_floating_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_network_image.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/events/data/enums/event_type.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/data/models/joined_event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:donation_management/feature/events/presentation/screens/add_edit_event_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/view_participants_screen.dart';
import 'package:donation_management/feature/messages/data/models/conversation_dto.dart';
import 'package:donation_management/feature/messages/presentation/blocs/message_cubit/message_cubit.dart';
import 'package:donation_management/feature/messages/presentation/screens/messages_screen.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:donation_management/feature/profile/presentation/widgets/custom_profile_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  final EventDetailsScreenArgs args;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool preventRebuild = false;

  List<Widget> _settingsOptions(BuildContext context, EventDto event) {
    List<Widget> options = [
      ListTile(
        onTap: () {
          Navigator.pop(context);

          Navigator.pushNamed(
            context,
            AppRouter.viewParticipantsScreen,
            arguments: ViewParticipantsScreenArgs(event: event),
          );
        },
        leading: const Icon(Icons.groups),
        title: Text(
          'View participants',
          style: AppStyle.kStyleRegular.copyWith(
            fontSize: 16.0,
            color: AppStyle.kColorBlack,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);

          Navigator.pushNamed(
            context,
            AppRouter.addEditEventScreen,
            arguments: AddEditEventScreenArgs(
              isEdit: true,
              event: event,
            ),
          );
        },
        leading: const Icon(Icons.edit),
        title: Text(
          'Edit event',
          style: AppStyle.kStyleRegular.copyWith(
            fontSize: 16.0,
            color: AppStyle.kColorBlack,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);

          DialogUtils.showConfirmationDialog(
            context,
            title: 'Confirmation',
            content: 'Are you sure you want to delete this event?',
            onPrimaryButtonPressed: () async {
              Navigator.pop(context);

              await context
                  .read<EventCubit>()
                  .deleteEvent(event.eventId!, event.eventPhotoUrl!);
            },
          );
        },
        leading: const Icon(
          Icons.delete,
          color: AppStyle.kColorRed,
        ),
        title: Text(
          'Delete event',
          style: AppStyle.kStyleRegular.copyWith(
            fontSize: 16.0,
            color: AppStyle.kColorRed,
          ),
        ),
      ),
    ];

    if (!widget.args.isOrganization) {
      options = [
        FutureBuilder<JoinedEventDto?>(
          future: context.read<EventCubit>().checkIfUserJoinedToEvent(
              eventId: event.eventId!, userId: widget.args.senderUser!.userId!),
          builder: (context, snapshot) {
            if (!snapshot.hasError &&
                snapshot.connectionState == ConnectionState.done) {
              bool isListed = snapshot.hasData;

              return ListTile(
                onTap: () {
                  Navigator.pop(context);

                  if (isListed) {
                    context.read<EventCubit>().unlistEvent(
                        eventId: event.eventId!,
                        userId: widget.args.senderUser!.userId!);
                  } else {
                    context.read<EventCubit>().listEvent(
                        eventId: event.eventId!,
                        eventCreatedBy: event.postedBy!,
                        userId: widget.args.senderUser!.userId!);
                  }
                },
                leading: const Icon(Icons.event, color: AppStyle.kPrimaryColor),
                title: Text(
                  isListed ? 'Unlist event' : 'List event',
                  style: AppStyle.kStyleRegular.copyWith(
                    fontSize: 16.sp,
                    color: AppStyle.kPrimaryColor,
                  ),
                ),
              );
            }

            return const CustomProgressIndicator(size: 20.0);
          },
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);

            context.read<MessageCubit>().createOrCheckConversation(
                receiverUserId: event.postedBy!,
                senderUserId: widget.args.senderUser!.userId!);
          },
          leading: const Icon(Icons.message),
          title: Text(
            'Message organization',
            style: AppStyle.kStyleRegular.copyWith(
              fontSize: 16.sp,
              color: AppStyle.kColorBlack,
            ),
          ),
        ),
      ];
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<MessageCubit, MessageState>(
            listener: (context, state) {
              if (state is MessageLoading) {
                CustomLoader.of(context).show();
              }

              if (state is MessageSuccess) {
                _popLoader(
                  context,
                  navigate: true,
                  conversation: state.conversation!,
                  receiverUser: state.receiverUser!,
                );
              }

              if (state is MessageError) {
                _popLoader(context);
              }
            },
          ),
          BlocListener<EventCubit, EventState>(
            listener: (context, state) {
              if (state is EventLoading) {
                if (state.preventBuild) {
                  setState(() {
                    preventRebuild = true;
                  });

                  CustomLoader.of(context).show();
                }
              }

              if (state is EventDeleteSuccess) {
                _popLoader(
                  context,
                  message: 'Event deleted successfully!',
                  closeScreen: true,
                );
              }

              if (state is EventListUnlistSuccess) {
                _popLoader(
                  context,
                  message:
                      'Event ${state.forUnlisting ? 'unlisted' : 'listed'} successfully!',
                );
              }

              if (state is EventError) {
                _popLoader(context, message: state.errorMessage!);
              }
            },
          ),
        ],
        child: StreamBuilder<DocumentSnapshot>(
          stream: (!preventRebuild)
              ? context
                  .read<EventCubit>()
                  .getEventDataStream(widget.args.event.eventId!)
              : null,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var eventData = snapshot.data!.data();
              if (eventData != null) {
                EventDto _event =
                    EventDto.fromJson(eventData as Map<String, dynamic>);

                return Stack(
                  children: [
                    _buildEventHeader(context, _event),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        elevation: 20.0,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.60,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppStyle.kColorWhite,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.0),
                              topRight: Radius.circular(24.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 56.0,
                              left: 27.0,
                              right: 27.0,
                            ),
                            child: _buildProfileData(context, _event),
                          ),
                        ),
                      ),
                    ),
                    _buildFloatingButtons(context, _event),
                  ],
                );
              }
            }

            return const CustomProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildEventHeader(BuildContext context, EventDto event) {
    String? eventImage = event.eventPhotoUrl;

    Widget widget = const SizedBox.shrink();

    if (eventImage != null) {
      widget = SizedBox(
        height: MediaQuery.of(context).size.height * 0.50,
        width: double.infinity,
        child: CustomNetworkImage(imageUrl: eventImage),
      );
    }

    return widget;
  }

  Widget _buildProfileData(BuildContext context, EventDto event) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.eventTitle ?? 'No Title',
            style: AppStyle.kStyleBold.copyWith(
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 24.0),
          FutureBuilder<UserDto>(
            future: context.read<ProfileCubit>().getUserData(event.postedBy!),
            builder: (context, snapshot) {
              String data = '...';

              if (snapshot.hasData) {
                data = snapshot.data!.organizationName ?? 'No Organization';
              }

              return CustomProfileText(
                label: 'Posted By',
                data: data,
              );
            },
          ),
          CustomProfileText(
            label: 'Date Posted',
            data: StringUtils.getFormattedDate(
                dateTime: event.createdAt ?? DateTime.now()),
          ),
          CustomProfileText(
            label: 'Event Date',
            data: StringUtils.getFormattedDate(
                dateTime: event.eventDate ?? DateTime.now()),
          ),
          CustomProfileText(
            label: 'Event Type',
            data: getEventType(event.eventType ?? 0),
          ),
          CustomProfileText(
            label: 'Event Description',
            data: event.eventDescription ?? 'No Description',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context, EventDto newEventData) {
    return Positioned(
      top: 45.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomFloatingButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            CustomFloatingButton(
              icon: Icons.menu,
              onPressed: () {
                DialogUtils.showGenericBottomSheet(
                  context,
                  header: 'Event Settings',
                  options: _settingsOptions(context, newEventData),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _popLoader(
    BuildContext context, {
    ConversationDto? conversation,
    UserDto? receiverUser,
    String? message,
    bool navigate = false,
    bool closeScreen = false,
  }) {
    SnackbarUtils.removeCurrentSnackbar(context: context);

    CustomLoader.of(context).managePop(true);
    CustomLoader.of(context).hide();

    if (navigate) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagesScreen(
            args: MessagesScreenArgs(
              conversation: conversation!,
              receiverUser: receiverUser!,
              senderUser: widget.args.senderUser!,
            ),
          ),
        ),
      );
    } else {
      SnackbarUtils.showSnackbar(
        context: context,
        title: message!,
      );

      if (closeScreen) {
        Navigator.pop(context);
      }
    }
  }
}

class EventDetailsScreenArgs {
  final EventDto event;
  final UserDto? senderUser;
  final bool isOrganization;

  EventDetailsScreenArgs({
    required this.event,
    this.senderUser,
    this.isOrganization = false,
  });
}
