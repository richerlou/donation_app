import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/widgets/custom_chip.dart';
import 'package:donation_management/core/presentation/widgets/custom_network_image.dart';
import 'package:donation_management/feature/events/data/enums/event_status.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventItemTile extends StatelessWidget {
  const EventItemTile({
    Key? key,
    required this.event,
    this.onItemPressed,
  }) : super(key: key);

  final EventDto event;
  final VoidCallback? onItemPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemPressed,
      child: Container(
        width: double.infinity,
        color: AppStyle.kColorTransparent,
        child: Row(
          children: [
            SizedBox(
              height: 80.0,
              width: 80.0,
              child: CustomNetworkImage(
                imageUrl: event.eventPhotoUrl!,
                imageBorderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      event.eventTitle!,
                      style: AppStyle.kStyleMedium,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      event.eventDescription!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.kStyleMedium,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomChip(
                backgroundColor: getEventStatusColor(event.eventStatus ?? 1),
                label: getEventStatus(event.eventStatus ?? 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
