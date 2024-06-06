part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageSuccess extends MessageState {
  final ConversationDto? conversation;
  final UserDto? receiverUser;

  const MessageSuccess({
    this.conversation,
    this.receiverUser,
  });

  @override
  List<Object> get props => [conversation!];
}

class MessageError extends MessageState {
  final String errorMessage;

  const MessageError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
