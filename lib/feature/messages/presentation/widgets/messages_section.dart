import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:donation_management/feature/messages/data/models/conversation_dto.dart';
import 'package:donation_management/feature/messages/presentation/blocs/message_cubit/message_cubit.dart';
import 'package:donation_management/feature/messages/presentation/screens/messages_screen.dart';
import 'package:donation_management/feature/messages/presentation/widgets/conversation_item_tile.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesSection extends StatelessWidget {
  const MessagesSection({
    super.key,
    required this.user,
  });

  final UserDto user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(centerTitle: true, title: 'Messages'),
      body: StreamBuilder<QuerySnapshot>(
        stream: context.read<MessageCubit>().getPostedConversations(
              user.userId!,
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            if (snapshot.data!.docs.isNotEmpty) {
              return _buildConversationList(snapshot.data!.docs);
            } else {
              return const Center(
                child: CustomEmptyPlaceholder(
                  iconData: Icons.message,
                  title: 'No messages received yet.',
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
      ),
    );
  }

  Widget _buildConversationList(List<QueryDocumentSnapshot> eventsSnapshot) {
    List<ConversationDto> conversationItems = <ConversationDto>[];

    for (QueryDocumentSnapshot element in eventsSnapshot) {
      conversationItems.add(
        ConversationDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: conversationItems.length,
      itemBuilder: (context, index) {
        String otherUser = conversationItems[index]
            .userIds!
            .where((element) => element != user.userId)
            .toList()
            .first;

        return FutureBuilder<UserDto>(
          future: context.read<ProfileCubit>().getUserData(otherUser),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              if (snapshot.data != null) {
                return ConversationItemTlle(
                  user: snapshot.data!,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagesScreen(
                          args: MessagesScreenArgs(
                            conversation: conversationItems[index],
                            receiverUser: snapshot.data!,
                            senderUser: user,
                          ),
                        ),
                      ),
                    );
                  },
                  stream: context
                      .read<MessageCubit>()
                      .getMessages(conversationItems[index].conversationId!),
                );
              }
            }

            return const SizedBox.shrink();
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
