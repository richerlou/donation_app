import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:donation_management/feature/events/data/enums/event_type.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/data/models/joined_event_dto.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class EventRepository {
  /// Get posted events by organization filtered by eventType via stream.
  Stream<QuerySnapshot>? getPostedEventByType({
    required String postedBy,
    required EventType eventType,
  });

  Stream<DocumentSnapshot>? getEventStream(String eventId);

  Future<EventDto>? getEventFuture(String eventId);

  Stream<QuerySnapshot>? getUserJoinedEvents(String userId);

  Future<String> uploadEventPhoto({
    required String eventId,
    required String uploadedFile,
  });

  /// Add event to `firestore`.
  Future<void> addEvent(
    String documentId, {
    required EventDto event,
  });

  /// Update event to `firestore`.
  Future<void> updateEvent(
    String documentId, {
    required EventDto event,
  });

  /// Delete event to `firestore`.
  Future<void> deleteEvent(String documentId);

  /// Delete event to `firestore`.
  Future<void> deleteEventPhoto(String eventPhotoUrl);

  /// Delete joined event to `firestore`.
  Future<void> deleteJoinedEvent(String eventId);

  Stream<QuerySnapshot>? getEvents();

  /// Join event to `firestore`.
  Future<void> listEvent(
    String documentId, {
    required JoinedEventDto joinedEvent,
  });

  /// Unjoin event to `firestore`.
  Future<void> unlistEvent(String documentId);

  Future<JoinedEventDto?> checkIfUserJoinedToEvent({
    required String userId,
    required String eventId,
  });

  /// Get all joined events by joinedEventId
  Future<List<JoinedEventDto>> getJoinedEvents(String eventId);

  Stream<QuerySnapshot>? getParticipants(String eventId);
}

class EventRepositoryImpl implements EventRepository {
  const EventRepositoryImpl(this._firebaseService);

  final FirebaseService _firebaseService;

  @override
  Stream<QuerySnapshot>? getPostedEventByType({
    required String postedBy,
    required EventType eventType,
  }) =>
      _firebaseService.eventsRef
          .where('postedBy', isEqualTo: postedBy)
          .where('eventType', isEqualTo: eventType.code())
          .orderBy('createdAt', descending: true)
          .snapshots();

  @override
  Stream<DocumentSnapshot>? getEventStream(String eventId) =>
      _firebaseService.eventsRef.doc(eventId).snapshots();

  @override
  Stream<QuerySnapshot>? getUserJoinedEvents(String userId) =>
      _firebaseService.joinedEventsRef
          .where('joinedBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots();

  @override
  Future<EventDto>? getEventFuture(String eventId) async {
    DocumentSnapshot query =
        await _firebaseService.eventsRef.doc(eventId).get();

    return EventDto.fromJson(query.data() as Map<String, dynamic>);
  }

  @override
  Future<String> uploadEventPhoto({
    required String eventId,
    required String uploadedFile,
  }) async =>
      await _firebaseService.uploadFile(
        UploadPathRef.events,
        fileName: eventId,
        uploadedFile: uploadedFile,
      );

  @override
  Future<void> addEvent(
    String documentId, {
    required EventDto event,
  }) async =>
      await _firebaseService.eventsRef.doc(documentId).set(event.toJson());

  @override
  Future<void> updateEvent(
    String documentId, {
    required EventDto event,
  }) async =>
      await _firebaseService.eventsRef.doc(documentId).update(event.toJson());

  @override
  Future<void> deleteEvent(String documentId) async =>
      await _firebaseService.eventsRef.doc(documentId).delete();

  @override
  Future<void> deleteEventPhoto(String eventPhotoUrl) async =>
      await FirebaseStorage.instance.refFromURL(eventPhotoUrl).delete();

  @override
  Future<void> deleteJoinedEvent(String id) async =>
      await _firebaseService.joinedEventsRef.doc(id).delete();

  @override
  Stream<QuerySnapshot>? getEvents() => _firebaseService.eventsRef
      .orderBy('createdAt', descending: true)
      .snapshots();

  @override
  Future<void> listEvent(
    String documentId, {
    required JoinedEventDto joinedEvent,
  }) async =>
      await _firebaseService.joinedEventsRef
          .doc(documentId)
          .set(joinedEvent.toJson());

  @override
  Future<void> unlistEvent(String documentId) async =>
      await _firebaseService.joinedEventsRef.doc(documentId).delete();

  @override
  Future<JoinedEventDto?> checkIfUserJoinedToEvent({
    required String userId,
    required String eventId,
  }) async {
    QuerySnapshot query = await _firebaseService.joinedEventsRef
        .where('joinedBy', isEqualTo: userId)
        .where('joinedEventId', isEqualTo: eventId)
        .get();

    return (query.docs.isNotEmpty)
        ? JoinedEventDto.fromJson(
            query.docs.first.data() as Map<String, dynamic>)
        : null;
  }

  @override
  Future<List<JoinedEventDto>> getJoinedEvents(String eventId) async {
    List<JoinedEventDto> tmpJoinedEvents = <JoinedEventDto>[];

    QuerySnapshot query = await _firebaseService.joinedEventsRef
        .where('joinedEventId', isEqualTo: eventId)
        .get();

    if (query.docs.isNotEmpty) {
      for (QueryDocumentSnapshot element in query.docs) {
        tmpJoinedEvents.add(
          JoinedEventDto.fromJson(element.data() as Map<String, dynamic>),
        );
      }
    }

    return tmpJoinedEvents;
  }

  @override
  Stream<QuerySnapshot>? getParticipants(String eventId) =>
      _firebaseService.joinedEventsRef
          .where('joinedEventId', isEqualTo: eventId)
          .orderBy('createdAt', descending: true)
          .snapshots();
}
