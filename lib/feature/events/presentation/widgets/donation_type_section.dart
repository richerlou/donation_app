import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/events/data/enums/donation_type.dart';
import 'package:donation_management/feature/events/data/models/donation_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/donation_cubit/donation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonationTypeSection extends StatelessWidget {
  const DonationTypeSection({
    Key? key,
    required this.eventId,
    required this.donationType,
  }) : super(key: key);

  final String eventId;
  final DonationType donationType;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context
          .read<DonationCubit>()
          .fetchDonations(eventId, donationType: donationType),
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          if (snapshot.data!.docs.isNotEmpty) {
            return _buildDonationsList(snapshot.data!.docs);
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
  }

  Widget _buildDonationsList(List<QueryDocumentSnapshot> donationsSnapshot) {
    List<DonationDto> _donations = <DonationDto>[];

    for (QueryDocumentSnapshot element in donationsSnapshot) {
      _donations.add(
        DonationDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 25.h),
      itemCount: _donations.length,
      itemBuilder: (context, index) {
        return DonationItemTile(
            name: _donations[index].donationName!,
            currentQuantity: _donations[index].donationQuantity!.toString(),
            targetQuantity:
                _donations[index].donationTargetQuantity!.toString());
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class DonationItemTile extends StatelessWidget {
  const DonationItemTile({
    Key? key,
    required this.name,
    required this.currentQuantity,
    required this.targetQuantity,
  }) : super(key: key);

  final String name;
  final String currentQuantity;
  final String targetQuantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 25.w),
      title: Text(
        name,
        style: AppStyle.kStyleBold.copyWith(
          fontSize: 17.sp,
        ),
      ),
      subtitle: Text(
        'Target donations: $targetQuantity',
        style: AppStyle.kStyleRegular.copyWith(
          fontSize: 14.sp,
          color: AppStyle.kColorGrey3,
        ),
      ),
      trailing: RichText(
        text: TextSpan(
          style: AppStyle.kStyleMedium.copyWith(
            fontSize: 16.sp,
          ),
          children: [
            TextSpan(
              text: currentQuantity,
              style: AppStyle.kStyleMedium.copyWith(
                fontSize: 16.sp,
                color: AppStyle.kColorGreen,
              ),
            ),
            const TextSpan(text: ' Donations')
          ],
        ),
      ),
    );
  }
}
