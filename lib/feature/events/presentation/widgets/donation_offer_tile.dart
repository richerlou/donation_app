import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/feature/events/data/enums/donation_offer_status.dart';
import 'package:donation_management/feature/events/data/models/donation_offer_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonationOfferTile extends StatelessWidget {
  const DonationOfferTile({
    Key? key,
    this.itemName,
    required this.donationOffer,
    this.onApprovedPressed,
    this.onDeclinedPressed,
  }) : super(key: key);

  final String? itemName;
  final DonationOfferDto donationOffer;
  final VoidCallback? onApprovedPressed;
  final VoidCallback? onDeclinedPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemName ?? 'None',
              style: AppStyle.kStyleMedium.copyWith(
                fontSize: 17.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Quantity: ${donationOffer.quantity}',
              style: AppStyle.kStyleRegular.copyWith(
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Date donated: ${StringUtils.getFormattedDate(dateTime: donationOffer.createdAt)}',
              style: AppStyle.kStyleRegular.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        (donationOffer.status == DonationOfferStatus.pending.code())
            ? _actionButtons()
            : _statusText(donationOffer.status!),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: onApprovedPressed,
          icon: Icon(
            Icons.check_circle,
            color: AppStyle.kPrimaryColor,
            size: 32.sp,
          ),
        ),
        IconButton(
          onPressed: onDeclinedPressed,
          icon: Icon(
            Icons.cancel,
            color: AppStyle.kColorRed,
            size: 32.sp,
          ),
        )
      ],
    );
  }

  Widget _statusText(num status) {
    Widget widget = const SizedBox.shrink();

    if (status == DonationOfferStatus.approved.code()) {
      widget = Text(
        'Approved',
        style: AppStyle.kStyleMedium.copyWith(
          color: AppStyle.kPrimaryColor,
        ),
      );
    } else {
      widget = Text(
        'Declined',
        style: AppStyle.kStyleMedium.copyWith(
          color: AppStyle.kColorRed,
        ),
      );
    }

    return widget;
  }
}
