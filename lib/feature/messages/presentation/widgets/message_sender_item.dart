import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_avatar.dart';
import 'package:donation_management/feature/messages/data/models/message_dto.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/screens/view_profile_screen.dart';
import 'package:flutter/material.dart';

class MessageSenderItem extends StatelessWidget {
  const MessageSenderItem({
    Key? key,
    required this.user,
    required this.message,
  }) : super(key: key);

  final UserDto user;
  final MessageDto message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppStyle.kColorGrey),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (user.getUserRole == UserRole.organization)
                          ? user.organizationName!
                          : '${user.firstName} ${user.lastName}',
                      style: AppStyle.kStyleBold,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      message.message!,
                      style: AppStyle.kStyleRegular,
                    ),
                    const SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        StringUtils.getFormattedDate(
                          dateFormat: 'MMMM dd, yyyy - hh:mm a',
                          dateTime: message.createdAt,
                        ),
                        style: AppStyle.kStyleRegular.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.viewProfileScreen,
                  arguments: ViewProfileScreenArgs(
                    user: user,
                    showEditIcon: false,
                  ),
                );
              },
              child: CustomAvatar(
                heroTag: message.messageId!,
                name: (user.getUserRole == UserRole.organization)
                    ? user.organizationName
                    : user.firstName,
                size: 50.0,
                fontSize: 15.0,
                networkAsset: user.profileImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
