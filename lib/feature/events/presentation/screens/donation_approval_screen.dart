import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/events/data/enums/donation_offer_status.dart';
import 'package:donation_management/feature/events/data/models/donation_dto.dart';
import 'package:donation_management/feature/events/data/models/donation_offer_dto.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/donation_cubit/donation_cubit.dart';
import 'package:donation_management/feature/events/presentation/widgets/donation_offer_tile.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonationApprovalScreen extends StatelessWidget {
  const DonationApprovalScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  final DonationApprovalScreenArgs args;

  void _popLoader(BuildContext context, String message,
      {bool closeScreen = false}) {
    SnackbarUtils.removeCurrentSnackbar(context: context);

    CustomLoader.of(context).managePop(true);
    CustomLoader.of(context).hide();

    SnackbarUtils.showSnackbar(
      context: context,
      title: message,
    );

    if (closeScreen) {
      Navigator.pop(context);
    }
  }

  void _handleActionButtons(
    BuildContext context,
    DonationOfferDto offer,
    DonationOfferStatus status,
  ) async {
    DialogUtils.showConfirmationDialog(
      context,
      title: 'Confirmation',
      content:
          'Are you sure you want ${(status == DonationOfferStatus.approved) ? 'approve' : 'decline'} this donation?',
      onPrimaryButtonPressed: () async {
        Navigator.pop(context);

        await context
            .read<DonationCubit>()
            .updateDonationOffer(args.user!, args.event!, offer, status);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Donations by ${args.user!.firstName}'),
      body: BlocConsumer<DonationCubit, DonationState>(
        listener: (context, state) {
          if (state is DonationLoading) {
            CustomLoader.of(context).show();
          }

          if (state is DonationSuccess) {
            _popLoader(context, state.message!);
          }

          if (state is DonationError) {
            _popLoader(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
            stream: context.read<DonationCubit>().fetchDonationOffers(
                userId: args.user!.userId!, eventId: args.joinedEventId!),
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return _buildDonationOffersList(context, snapshot.data!.docs);
                } else {
                  return const Center(
                    child: CustomEmptyPlaceholder(
                      iconData: Icons.inventory,
                      title: 'No donations added yet.',
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
        },
      ),
    );
  }

  Widget _buildDonationOffersList(
    BuildContext context,
    List<QueryDocumentSnapshot> snapshot,
  ) {
    List<DonationOfferDto> _donationOffers = <DonationOfferDto>[];

    for (QueryDocumentSnapshot element in snapshot) {
      _donationOffers.add(
        DonationOfferDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 23.w),
      itemCount: _donationOffers.length,
      itemBuilder: (context, index) {
        return FutureBuilder<DonationDto?>(
          future: context.read<DonationCubit>().getDonation(
              eventId: _donationOffers[index].eventId!,
              donationId: _donationOffers[index].itemId!),
          builder: (context, snapshot) {
            String itemName = '...';

            if (snapshot.hasData) {
              itemName = snapshot.data!.donationName!;
            }

            return DonationOfferTile(
              itemName: itemName,
              donationOffer: _donationOffers[index],
              onApprovedPressed: () => _handleActionButtons(
                context,
                _donationOffers[index],
                DonationOfferStatus.approved,
              ),
              onDeclinedPressed: () => _handleActionButtons(
                context,
                _donationOffers[index],
                DonationOfferStatus.declined,
              ),
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class DonationApprovalScreenArgs {
  final UserDto? user;
  final EventDto? event;
  final String? joinedEventId;

  DonationApprovalScreenArgs({
    this.user,
    this.event,
    this.joinedEventId,
  });
}
