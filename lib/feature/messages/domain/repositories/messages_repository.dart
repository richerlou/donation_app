import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:donation_management/feature/messages/data/models/conversation_dto.dart';
import 'package:donation_management/feature/messages/data/models/message_dto.dart';

abstract class MessageRepository {
  Stream<QuerySnapshot>? getConversationsByUser(String userId);

  Stream<QuerySnapshot>? getMessagesStream(String conversationId);

  /// Sets message to `firestore`.
  Future<void> sendMessage({
    required String conversationId,
    required String messageId,
    required MessageDto messageData,
  });

  Future<bool> checkConversation(String conversationKey);

  Future<ConversationDto> getConversation(String conversationKey);

  /// Sets conversation to `firestore`.
  Future<void> createConversation({
    required String conversationId,
    required ConversationDto conversationData,
  });

  /// Update conversation to `firestore`.
  Future<void> updateConversation(ConversationDto conversationData);

  /// Delete conversation to `firestore`.
  Future<void> deleteConversation(String conversationId);
}

class MessageRepositoryImpl implements MessageRepository {
  const MessageRepositoryImpl(this._firebaseService);

  final FirebaseService _firebaseService;

  @override
  Stream<QuerySnapshot>? getConversationsByUser(
    String userId, {
    UserRole? userRole,
  }) {
    String? field = 'isIndividual';

    if (userRole == UserRole.organization) {
      field = 'isOrganization';
    }

    return _firebaseService.conversationsRef
        .where('userIds', arrayContains: userId)
        .where(field, isEqualTo: false)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot>? getMessagesStream(String conversationId) =>
      _firebaseService.conversationsRef
          .doc(conversationId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots();

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String messageId,
    required MessageDto messageData,
  }) async =>
      await _firebaseService.conversationsRef
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .set(messageData.toJson());

  @override
  Future<bool> checkConversation(String conversationKey) async {
    QuerySnapshot query = await _firebaseService.conversationsRef
        .where('conversationKeys', arrayContains: conversationKey)
        .orderBy('updatedAt', descending: true)
        .get();

    return query.docs.isNotEmpty;
  }

  @override
  Future<ConversationDto> getConversation(String conversationKey) async {
    QuerySnapshot query = await _firebaseService.conversationsRef
        .where('conversationKeys', arrayContains: conversationKey)
        .orderBy('updatedAt', descending: true)
        .get();

    return ConversationDto.fromJson(
      query.docs.first.data() as Map<String, dynamic>,
    );
  }

  @override
  Future<void> createConversation({
    required String conversationId,
    required ConversationDto conversationData,
  }) async =>
      await _firebaseService.conversationsRef
          .doc(conversationId)
          .set(conversationData.toJson());

  @override
  Future<void> updateConversation(ConversationDto conversationData) async =>
      await _firebaseService.conversationsRef
          .doc(conversationData.conversationId)
          .update(conversationData.toJson());

  @override
  Future<void> deleteConversation(String conversationId) async =>
      await _firebaseService.conversationsRef.doc(conversationId).delete();
}
