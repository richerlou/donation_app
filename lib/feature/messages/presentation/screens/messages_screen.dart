import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/messages/data/models/conversation_dto.dart';
import 'package:donation_management/feature/messages/data/models/message_dto.dart';
import 'package:donation_management/feature/messages/presentation/blocs/message_cubit/message_cubit.dart';
import 'package:donation_management/feature/messages/presentation/widgets/message_receiver_item.dart';
import 'package:donation_management/feature/messages/presentation/widgets/message_sender_item.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    super.key,
    required this.args,
  });

  final MessagesScreenArgs args;

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  FormGroup? _messageForm;

  @override
  void initState() {
    _messageForm = FormGroup({
      'message': FormControl<String>(validators: [Validators.required]),
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: (widget.args.receiverUser.getUserRole == UserRole.organization)
            ? widget.args.receiverUser.organizationName!
            : '${widget.args.receiverUser.firstName} ${widget.args.receiverUser.lastName}',
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: context
                  .read<MessageCubit>()
                  .getMessages(widget.args.conversation.conversationId!),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return _buildMessageList(snapshot.data!.docs);
                  }
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          const Divider(),
          ReactiveForm(
            formGroup: _messageForm!,
            child: CustomTextField(
              'message',
              label: 'Please enter your message here...',
              enableLabel: false,
              formInsetPadding: EdgeInsets.zero,
              prefixIcon: const Icon(Icons.account_circle_outlined),
              textfieldBorderColor: AppStyle.kColorTransparent,
              suffixIcon: ReactiveFormConsumer(
                builder: (context, form, child) {
                  return IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _messageForm!.valid
                        ? () async {
                            await context.read<MessageCubit>().sendMessage(
                                  conversationId:
                                      widget.args.conversation.conversationId,
                                  messageForm: _messageForm!,
                                  senderId: widget.args.senderUser.userId,
                                );
                          }
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<QueryDocumentSnapshot> messageSnapshot) {
    List<MessageDto> messages = <MessageDto>[];

    for (QueryDocumentSnapshot element in messageSnapshot) {
      messages.add(
        MessageDto.fromJson(element.data() as Map<String, dynamic>),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return (messages[index].senderId == widget.args.senderUser.userId)
              ? MessageSenderItem(
                  user: widget.args.senderUser,
                  message: messages[index],
                )
              : MessageReceiverItem(
                  user: widget.args.receiverUser,
                  message: messages[index],
                );
        },
      ),
    );
  }
}

class MessagesScreenArgs {
  final ConversationDto conversation;
  final UserDto receiverUser;
  final UserDto senderUser;

  MessagesScreenArgs({
    required this.conversation,
    required this.receiverUser,
    required this.senderUser,
  });
}
