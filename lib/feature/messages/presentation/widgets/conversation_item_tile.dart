import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_avatar.dart';
import 'package:donation_management/feature/messages/data/models/message_dto.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';

class ConversationItemTlle extends StatelessWidget {
  const ConversationItemTlle({
    super.key,
    required this.user,
    required this.onPressed,
    required this.stream,
  });

  final UserDto user;
  final VoidCallback onPressed;
  final Stream<QuerySnapshot>? stream;

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
              name: (user.getUserRole == UserRole.organization)
                  ? user.organizationName
                  : user.firstName,
              size: 60.0,
              fontSize: 15.0,
              borderWidth: 3.0,
              networkAsset: user.profileImage,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (user.getUserRole == UserRole.organization)
                        ? user.organizationName!
                        : '${user.firstName} ${user.lastName}',
                    style: AppStyle.kStyleBold.copyWith(
                      fontSize: 17.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          MessageDto message = MessageDto.fromJson(
                            snapshot.data!.docs.first.data()
                                as Map<String, dynamic>,
                          );

                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  message.message!,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyle.kStyleRegular,
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Text(
                                  ' ${StringUtils.getFormattedDate(dateTime: message.createdAt)}',
                                  style: AppStyle.kStyleRegular,
                                ),
                              ),
                            ],
                          );
                        }
                      }

                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
