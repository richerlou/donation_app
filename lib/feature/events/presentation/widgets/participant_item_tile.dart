import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:donation_management/core/presentation/widgets/custom_avatar.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParticipantItemTile extends StatelessWidget {
  const ParticipantItemTile({
    super.key,
    required this.user,
    required this.onPressed,
  });

  final UserDto user;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CustomAvatar(
              heroTag: StringUtils.generateId(),
              name: user.firstName,
              size: 60.0,
              fontSize: 15.sp,
              borderWidth: 3.w,
              networkAsset: user.profileImage,
            ),
            SizedBox(width: 10.w),
            Text(
              '${user.firstName} ${user.lastName}',
              style: AppStyle.kStyleBold.copyWith(
                fontSize: 17.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
