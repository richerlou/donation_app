import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/feature/events/data/enums/donation_type.dart';
import 'package:donation_management/feature/events/data/enums/event_status.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/data/models/joined_event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:donation_management/feature/events/presentation/screens/add_edit_event_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/donation_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/give_donation_screen.dart';
import 'package:donation_management/feature/events/presentation/screens/view_participants_screen.dart';
import 'package:donation_management/feature/messages/presentation/blocs/message_cubit/message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin EventDetailsMixin {
  List<Widget> buildSettings(
    BuildContext context, {
    EventDto? event,
    String? senderId,
    bool? isOrganization,
  }) =>
      (isOrganization!)
          ? _buildOrganizationOptions(
              context,
              event: event!,
              isOrganization: isOrganization,
            )
          : _buildIndividualOptions(
              context,
              event!,
              senderId!,
              isOrganization,
            );

  List<Widget> _buildIndividualOptions(
    BuildContext context,
    EventDto event,
    String senderId,
    bool isOrganization,
  ) {
    return [
      if (event.eventStatus != EventStatus.cancelled.code() &&
          event.eventStatus != EventStatus.completed.code())
        FutureWrapper(
          event: event,
          senderId: senderId,
          child: (isListed) {
            return ListTile(
              onTap: () =>
                  _listUnlistToEvent(context, event, senderId, isListed),
              leading: const Icon(
                Icons.event,
                color: AppStyle.kPrimaryColor,
              ),
              title: Text(
                (isListed) ? 'Unlist event' : 'List event',
                style: AppStyle.kStyleRegular.copyWith(
                  fontSize: 16.sp,
                  color: AppStyle.kPrimaryColor,
                ),
              ),
            );
          },
        ),
      if (event.eventStatus != EventStatus.cancelled.code() &&
          event.eventStatus != EventStatus.completed.code())
        FutureWrapper(
          event: event,
          senderId: senderId,
          child: (isListed) {
            return ListTile(
              onTap: (isListed && !event.isDonationClosed!)
                  ? () => _giveDonation(context, event)
                  : null,
              leading: const Icon(Icons.inventory),
              title: Text(
                'Give donation',
                style: AppStyle.kStyleRegular.copyWith(
                  fontSize: 16.sp,
                  color: (isListed && !event.isDonationClosed!)
                      ? null
                      : AppStyle.kColorBlack.withOpacity(0.50),
                ),
              ),
            );
          },
        ),
      ListTile(
        onTap: () => _viewDonation(context, event, isOrganization),
        leading: const Icon(Icons.inventory),
        title: Text(
          'View donations',
          style: AppStyle.kStyleRegular.copyWith(
            fontSize: 16.sp,
            color: AppStyle.kColorBlack,
          ),
        ),
      ),
      ListTile(
        onTap: () => _messageOrganization(context, event, senderId),
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

  List<Widget> _buildOrganizationOptions(
    BuildContext context, {
    required EventDto event,
    required bool isOrganization,
  }) {
    return [
      if (event.eventStatus != EventStatus.cancelled.code() &&
          event.eventStatus != EventStatus.completed.code())
        ListTile(
          onTap: () => _editEvent(context, event),
          leading: const Icon(Icons.edit),
          title: Text(
            'Edit event',
            style: AppStyle.kStyleRegular.copyWith(
              fontSize: 16.sp,
              color: AppStyle.kColorBlack,
            ),
          ),
        ),
      if (event.eventStatus != EventStatus.cancelled.code() &&
          event.eventStatus != EventStatus.completed.code())
        ListTile(
          onTap: () => _startCompleteEvent(context, event),
          leading: Icon(
            (event.eventStatus == EventStatus.onGoing.code())
                ? Icons.event_available
                : Icons.today,
            color: AppStyle.kPrimaryColor,
          ),
          title: Text(
            (event.eventStatus == EventStatus.onGoing.code())
                ? 'Complete event'
                : 'Start event',
            style: AppStyle.kStyleRegular.copyWith(
              fontSize: 16.sp,
              color: AppStyle.kPrimaryColor,
            ),
          ),
        ),
      ListTile(
        onTap: () => _viewDonation(context, event, isOrganization),
        leading: const Icon(Icons.inventory),
        title: Text(
          'View donations',
          style: AppStyle.kStyleRegular.copyWith(
            fontSize: 16.sp,
            color: AppStyle.kColorBlack,
          ),
        ),
      ),
      if (event.eventStatus == EventStatus.onGoing.code())
        ListTile(
          onTap: () => _closeReOpenDonations(context, event),
          leading: const Icon(Icons.inventory_sharp),
          title: Text(
            (event.isDonationClosed!) ? 'Re-open donations' : 'Close donations',
            style: AppStyle.kStyleRegular.copyWith(
              fontSize: 16.sp,
              color: AppStyle.kColorBlack,
            ),
          ),
        ),
      ListTile(
        onTap: () => _viewParticipants(context, event),
        leading: const Icon(Icons.groups),
        title: Text(
          'View participants',
          style: AppStyle.kStyleRegular.copyWith(
            fontSize: 16.sp,
            color: AppStyle.kColorBlack,
          ),
        ),
      ),
      if (event.eventStatus != EventStatus.cancelled.code() &&
          event.eventStatus != EventStatus.completed.code())
        ListTile(
          onTap: () => _cancelEvent(context, event),
          leading: const Icon(
            Icons.cancel,
            color: AppStyle.kColorRed,
          ),
          title: Text(
            'Cancel event',
            style: AppStyle.kStyleRegular.copyWith(
              fontSize: 16.sp,
              color: AppStyle.kColorRed,
            ),
          ),
        ),
    ];
  }

  void _viewDonation(
    BuildContext context,
    EventDto event,
    bool isOrganization,
  ) {
    Navigator.pop(context);

    bool showAddDonation = true;

    if (!isOrganization ||
        (event.eventStatus == EventStatus.cancelled.code() ||
            event.eventStatus == EventStatus.completed.code() &&
                isOrganization)) {
      showAddDonation = false;
    }

    Navigator.pushNamed(
      context,
      AppRouter.donationScreen,
      arguments: DonationScreenArgs(
        event: event,
        showAddDonation: showAddDonation,
      ),
    );
  }

  void _viewParticipants(BuildContext context, EventDto event) {
    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      AppRouter.viewParticipantsScreen,
      arguments: ViewParticipantsScreenArgs(event: event),
    );
  }

  void _editEvent(BuildContext context, EventDto event) {
    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      AppRouter.addEditEventScreen,
      arguments: AddEditEventScreenArgs(isEdit: true, event: event),
    );
  }

  void _cancelEvent(BuildContext context, EventDto event) {
    Navigator.pop(context);

    DialogUtils.showConfirmationDialog(
      context,
      title: 'Confirmation',
      content: 'Are you sure you want to cancel this event?',
      onPrimaryButtonPressed: () async {
        Navigator.pop(context);

        await context
            .read<EventCubit>()
            .changeEventStatus(event, EventStatus.cancelled);
      },
    );
  }

  void _messageOrganization(
    BuildContext context,
    EventDto event,
    String senderId,
  ) {
    Navigator.pop(context);

    context.read<MessageCubit>().createOrCheckConversation(
        receiverUserId: event.postedBy!, senderUserId: senderId);
  }

  void _giveDonation(BuildContext context, EventDto event) {
    DialogUtils.showDefaultDialog(
      context,
      title: 'Choose your type of donation:',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            buttonTitle: 'Services',
            onPressed: () => _handleNavigation(context, event: event),
          ),
          SizedBox(height: 10.h),
          CustomButton(
            buttonTitle: 'Materials',
            onPressed: () => _handleNavigation(
              context,
              donationType: DonationType.material,
              event: event,
            ),
          ),
        ],
      ),
      primaryButtonTitle: 'Close',
      onPrimaryButtonPressed: () => Navigator.pop(context),
    );
  }

  void _handleNavigation(
    BuildContext context, {
    DonationType donationType = DonationType.service,
    required EventDto event,
  }) {
    Navigator.pop(context);
    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      AppRouter.giveDonationScreen,
      arguments: GiveDonationScreenArgs(
        donationType: donationType,
        event: event,
      ),
    );
  }

  void _listUnlistToEvent(
    BuildContext context,
    EventDto event,
    String senderId,
    bool isListed,
  ) {
    Navigator.pop(context);

    if (isListed) {
      context
          .read<EventCubit>()
          .unlistEvent(eventId: event.eventId!, userId: senderId);
    } else {
      context.read<EventCubit>().listEvent(
          eventId: event.eventId!,
          eventStatus: event.eventStatus!,
          eventCreatedBy: event.postedBy!,
          userId: senderId);
    }
  }

  void _startCompleteEvent(
    BuildContext context,
    EventDto event,
  ) {
    Navigator.pop(context);

    DialogUtils.showConfirmationDialog(
      context,
      title: 'Confirmation',
      content:
          'Are you sure you want to ${(event.eventStatus == EventStatus.notYetStarted.code() || event.eventStatus == EventStatus.rescheduled.code()) ? 'start' : 'complete'} this event? You cannot undo this action once submitted.',
      onPrimaryButtonPressed: () async {
        Navigator.pop(context);

        EventStatus? eventStatus;

        if (event.eventStatus == EventStatus.notYetStarted.code() ||
            event.eventStatus == EventStatus.rescheduled.code()) {
          eventStatus = EventStatus.onGoing;
        } else if (event.eventStatus == EventStatus.onGoing.code()) {
          eventStatus = EventStatus.completed;
        }

        await context.read<EventCubit>().changeEventStatus(event, eventStatus!);
      },
    );
  }
}

void _closeReOpenDonations(BuildContext context, EventDto event) {
  Navigator.pop(context);

  DialogUtils.showConfirmationDialog(
    context,
    title: 'Confirmation',
    content:
        'Are you sure you want to ${(event.isDonationClosed!) ? 're-open' : 'close'} the donations?',
    onPrimaryButtonPressed: () async {
      Navigator.pop(context);

      await context
          .read<EventCubit>()
          .closeReOpenDonation(event.eventId!, !event.isDonationClosed!);
    },
  );
}

class FutureWrapper extends StatelessWidget {
  const FutureWrapper({
    super.key,
    required this.event,
    required this.senderId,
    required this.child,
  });

  final EventDto event;
  final String senderId;

  final Widget Function(bool isListed) child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JoinedEventDto?>(
      future: context
          .read<EventCubit>()
          .checkIfUserJoinedToEvent(eventId: event.eventId!, userId: senderId),
      builder: (context, snapshot) {
        bool isListed = false;

        if (!snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          isListed = snapshot.hasData;
        }

        return child(isListed);
      },
    );
  }
}
