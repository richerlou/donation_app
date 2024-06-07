import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/data/models/slidable_action_dto.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_avatar.dart';
import 'package:donation_management/feature/messages/data/models/message_dto.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ConversationItemTlle extends StatelessWidget {
  const ConversationItemTlle({
    Key? key,
    required this.user,
    required this.onPressed,
    required this.stream,
    this.actions,
  }) : super(key: key);

  final UserDto user;
  final VoidCallback onPressed;
  final Stream<QuerySnapshot>? stream;

  final List<SlidableActionDto>? actions;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: actions!
            .map(
              (e) => CustomSlidableAction(
                backgroundColor: e.backgroundColor!,
                foregroundColor: e.foregroundColor!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(e.icon),
                    SizedBox(height: 5.h),
                    Text(
                      e.label!,
                      style: AppStyle.kStyleMedium.copyWith(
                        color: e.foregroundColor!,
                      ),
                    ),
                  ],
                ),
                onPressed: e.onPressed,
              ),
            )
            .toList(),
      ),
      child: InkWell(
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
                                    ' ${StringUtils.getFormattedDate(
                                      dateFormat: 'MMMM dd, yyyy - hh:mm a',
                                      dateTime: message.createdAt,
                                    )}',
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
      ),
    );
  }
}
