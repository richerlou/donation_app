import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/models/slidable_action_dto.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_empty_placeholder.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
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
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserDto user;

  void handleDeleteConversation(
    BuildContext context,
    ConversationDto conversation,
    String receiverUserId,
  ) {
    DialogUtils.showConfirmationDialog(
      context,
      title: 'Confirmation',
      content: 'Are you sure you want to delete this conversation?',
      onPrimaryButtonPressed: () async {
        Navigator.pop(context);

        await context.read<MessageCubit>().deleteConversation(
            conversation: conversation, receiverUserId: receiverUserId);
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(centerTitle: true, title: 'Messages'),
      body: BlocConsumer<MessageCubit, MessageState>(
        listener: (context, state) {
          if (state is MessageLoading) {
            CustomLoader.of(context).show();
          }

          if (state is MessageSuccess) {
            _popLoader(context, 'Message deleted!');
          }

          if (state is MessageError) {
            _popLoader(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
            stream: context
                .read<MessageCubit>()
                .getPostedConversations(user.userId!, user.getUserRole),
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
          );
        },
      ),
    );
  }

  Widget _buildConversationList(List<QueryDocumentSnapshot> eventsSnapshot) {
    List<ConversationDto> _conversationItems = <ConversationDto>[];

    for (QueryDocumentSnapshot element in eventsSnapshot) {
      _conversationItems.add(
        ConversationDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: _conversationItems.length,
      itemBuilder: (context, index) {
        String otherUser = _conversationItems[index]
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
                  key: ValueKey(key),
                  actions: [
                    SlidableActionDto(
                      backgroundColor: AppStyle.kColorRed,
                      foregroundColor: AppStyle.kColorWhite,
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: (_) => handleDeleteConversation(
                        context,
                        _conversationItems[index],
                        otherUser,
                      ),
                    ),
                  ],
                  user: snapshot.data!,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagesScreen(
                          args: MessagesScreenArgs(
                            conversation: _conversationItems[index],
                            receiverUser: snapshot.data!,
                            senderUser: user,
                          ),
                        ),
                      ),
                    );
                  },
                  stream: context
                      .read<MessageCubit>()
                      .getMessages(_conversationItems[index].conversationId!),
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
