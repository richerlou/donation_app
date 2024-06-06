import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/feature/messages/data/models/conversation_dto.dart';
import 'package:donation_management/feature/messages/data/models/message_dto.dart';
import 'package:donation_management/feature/messages/domain/repositories/messages_repository.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(
    this._messageRepository,
    this._userRepository,
  ) : super(MessageInitial());

  final MessageRepositoryImpl _messageRepository;
  final UserRepositoryImpl _userRepository;

  Stream<QuerySnapshot>? getPostedConversations(String userId) =>
      _messageRepository.getConversationsByUser(userId);

  Stream<QuerySnapshot>? getMessages(String conversationId) =>
      _messageRepository.getMessagesStream(conversationId);

  Future<void> sendMessage({
    String? conversationId,
    String? senderId,
    required FormGroup messageForm,
  }) async {
    MessageDto messageData = MessageDto(
      messageId: StringUtils.generateId(),
      senderId: senderId,
      message: messageForm.control('message').value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _messageRepository.sendMessage(
      conversationId: conversationId!,
      messageId: messageData.messageId!,
      messageData: messageData,
    );

    messageForm.control('message').reset();
  }

  Future<void> createOrCheckConversation({
    required String senderUserId,
    required String receiverUserId,
  }) async {
    emit(MessageLoading());

    try {
      bool ifConversationExists = await _messageRepository.checkConversation(
        receiverUserId,
      );

      if (ifConversationExists) {
        ConversationDto _conversation =
            await _messageRepository.getConversation(
          receiverUserId,
        );

        UserDto receiverUser = await _userRepository.getUser(receiverUserId);

        emit(MessageSuccess(
          conversation: _conversation,
          receiverUser: receiverUser,
        ));
      } else {
        ConversationDto _conversation = ConversationDto(
          conversationId: StringUtils.generateId(),
          userIds: [receiverUserId, senderUserId],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        UserDto receiverUser = await _userRepository.getUser(receiverUserId);

        await _messageRepository.createConversation(
          conversationId: _conversation.conversationId!,
          conversationData: _conversation,
        );

        emit(MessageSuccess(
          conversation: _conversation,
          receiverUser: receiverUser,
        ));
      }
    } catch (err) {
      if (err is SocketException) {
        emit(const MessageError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const MessageError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }
}
