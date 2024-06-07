import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/data/mixins/local_user_mixin.dart';
import 'package:donation_management/core/data/models/notification_data_dto.dart';
import 'package:donation_management/core/data/services/firebase_messaging_service.dart';
import 'package:donation_management/core/presentation/utils/string_utils.dart';
import 'package:donation_management/feature/messages/data/models/conversation_dto.dart';
import 'package:donation_management/feature/messages/data/models/message_dto.dart';
import 'package:donation_management/feature/messages/domain/repositories/messages_repository.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> with LocalUserMixin {
  MessageCubit(
    this._messageRepository,
    this._userRepository,
  ) : super(MessageInitial());

  final MessageRepositoryImpl _messageRepository;
  final UserRepositoryImpl _userRepository;

  Stream<QuerySnapshot>? getPostedConversations(
          String userId, UserRole userRole) =>
      _messageRepository.getConversationsByUser(userId, userRole: userRole);

  Stream<QuerySnapshot>? getMessages(String conversationId) =>
      _messageRepository.getMessagesStream(conversationId);

  Future<void> sendMessage({
    ConversationDto? conversation,
    String? senderId,
    String? receiverId,
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
      conversationId: conversation!.conversationId!,
      messageId: messageData.messageId!,
      messageData: messageData,
    );

    if (conversation.isIndividual! || conversation.isOrganization!) {
      ConversationDto activateConversation = ConversationDto(
        conversationId: conversation.conversationId,
        isIndividual: false,
        isOrganization: false,
        updatedAt: DateTime.now(),
      );

      await _messageRepository.updateConversation(activateConversation);
    }

    messageForm.control('message').reset();

    String? name;
    UserDto receiverUser = await _userRepository.getUser(receiverId!);

    if (receiverUser.getUserRole == UserRole.organization) {
      name = receiverUser.organizationName;
    } else {
      name = receiverUser.firstName;
    }

    Map<String, dynamic> notification = NotificationDto(
      fcmToken: receiverUser.fcmToken ?? '',
      body: NotificationBodyDto(
        title: 'Messages',
        body: 'You received a message from $name.',
      ).toJson(),
    ).toJson();

    await FirebaseMessagingService.sendPushMessage(jsonEncode(notification));
  }

  Future<void> createOrCheckConversation({
    required String senderUserId,
    required String receiverUserId,
  }) async {
    emit(MessageLoading());

    try {
      // If there's an existing conversation between the sender & receiver.
      String conversationKey = '$senderUserId-$receiverUserId';

      bool ifConversationExists = await _messageRepository.checkConversation(
        conversationKey,
      );

      if (ifConversationExists) {
        ConversationDto _conversation =
            await _messageRepository.getConversation(conversationKey);

        UserDto receiverUser = await _userRepository.getUser(receiverUserId);

        emit(MessageSuccess(
          conversation: _conversation,
          receiverUser: receiverUser,
        ));
      } else {
        String conversationKey1 = '$senderUserId-$receiverUserId';
        String conversationKey2 = '$receiverUserId-$senderUserId';

        ConversationDto _conversation = ConversationDto(
          conversationId: StringUtils.generateId(),
          isIndividual: false,
          isOrganization: false,
          userIds: [receiverUserId, senderUserId],
          conversationKeys: [conversationKey1, conversationKey2],
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

  Future<void> deleteConversation({
    required ConversationDto conversation,
    required String receiverUserId,
  }) async {
    emit(MessageLoading());

    UserDto? user;
    ConversationDto conversationData = ConversationDto(
      conversationId: conversation.conversationId,
      updatedAt: DateTime.now(),
    );

    try {
      user = await loadLocalUser();

      if (user.getUserRole == UserRole.individual) {
        conversationData.isIndividual = true;
      } else {
        conversationData.isOrganization = true;
      }

      // If there's an existing conversation between the sender & receiver.
      String senderUserId = user.userId!;
      String conversationKey = '$senderUserId-$receiverUserId';

      await _messageRepository.updateConversation(conversationData);

      ConversationDto updatedConversation =
          await _messageRepository.getConversation(conversationKey);

      if (updatedConversation.isIndividual! &&
          updatedConversation.isOrganization!) {
        await _messageRepository
            .deleteConversation(updatedConversation.conversationId!);
      }

      emit(const MessageSuccess());
    } catch (err) {
      if (user!.getUserRole == UserRole.individual) {
        conversationData.isIndividual = false;
      } else {
        conversationData.isOrganization = false;
      }

      await _messageRepository.updateConversation(conversationData);

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
