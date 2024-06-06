import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum UploadPathRef { users, events, tradeOffers, proofs }

class FirebaseService {
  FirebaseService._();

  /// Singleton to ensure only one class instance is created
  static final FirebaseService _instance = FirebaseService._();
  factory FirebaseService() => _instance;

  static Future<void> init() async {
    await Firebase.initializeApp();
  }

  // --- Firestore --- //

  /// Custom getter - Firestore
  CollectionReference get usersRef => _users;
  CollectionReference get eventsRef => _events;
  CollectionReference get joinedEventsRef => _joinedEvents;
  CollectionReference get conversationsRef => _conversations;
  CollectionReference get messagesRef => _messages;

  /// Initialize referencesS
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _events =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference _joinedEvents =
      FirebaseFirestore.instance.collection('joinedEvents');
  final CollectionReference _conversations =
      FirebaseFirestore.instance.collection('conversations');
  final CollectionReference _messages =
      FirebaseFirestore.instance.collection('messages');

  // --- Firebase Authentication --- //

  /// Custom getter - FirebaseAuth
  FirebaseAuth get authInstance => _auth!;
  User get currentUserStatus => _currentUser!;

  /// Initialize FirebaseAuth instance
  final FirebaseAuth? _auth = FirebaseAuth.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // --- Firebase Storage --- //

  Future<String> uploadFile(
    UploadPathRef uploadPathRef, {
    String? subPath,
    required String uploadedFile,
    required String fileName,
  }) async {
    String uploadPath = 'uploads/users/';

    if (uploadPathRef == UploadPathRef.events) {
      uploadPath = 'uploads/events/';
    } else if (uploadPathRef == UploadPathRef.tradeOffers) {
      if (subPath != null) {
        uploadPath = 'uploads/tradeOffers/$subPath/';
      } else {
        uploadPath = 'uploads/tradeOffers/';
      }
    } else if (uploadPathRef == UploadPathRef.proofs) {
      uploadPath = 'uploads/proofs/';
    }

    File file = File(uploadedFile);
    await FirebaseStorage.instance.ref('$uploadPath$fileName').putFile(file);

    return await FirebaseStorage.instance
        .ref('$uploadPath$fileName')
        .getDownloadURL();
  }
}
