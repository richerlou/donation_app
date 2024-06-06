part of 'event_cubit.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {
  final bool preventBuild;

  const EventLoading({this.preventBuild = false});

  @override
  List<Object> get props => [preventBuild];
}

class EventPhotoFetched extends EventState {
  final String? eventPhoto;

  const EventPhotoFetched({this.eventPhoto});

  @override
  List<Object> get props => [eventPhoto!];
}

class EventSuccess extends EventState {}

class EventDeleteSuccess extends EventState {}

class EventListUnlistSuccess extends EventState {
  final bool forUnlisting;

  const EventListUnlistSuccess({this.forUnlisting = false});

  @override
  List<Object> get props => [forUnlisting];
}

class EventError extends EventState {
  final String? errorMessage;

  const EventError({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}
