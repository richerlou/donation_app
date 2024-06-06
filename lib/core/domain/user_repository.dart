import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';

abstract class UserRepository {
  /// Get current user data.
  Future<UserDto> getUser(String userId);

  /// Get current user data.
  Future<UserDto?> getUserByEmail(String emailAddress);

  /// Get current user data via stream.
  Stream<DocumentSnapshot>? getUserStream(String userId);

  /// Check if `emailAddress` exists
  Future<bool> checkIfEmailAddressExists(String usernameQuery);

  /// Update registered user details to `firestore`.
  Future<void> updateUser(
    String documentId, {
    required UserDto updateProfileData,
  });

  /// Update profile photo to `firebase storage`.
  Future<String> updateProfilePhoto({
    required String userId,
    required String uploadedFile,
  });

  /// Sets newly registered user to `firestore`.
  Future<void> storeRegisteredUser(
    String documentId, {
    required UserDto registrationData,
  });

  Stream<QuerySnapshot>? getOrganizations();
}

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._firebaseService);

  final FirebaseService _firebaseService;

  @override
  Future<bool> checkIfEmailAddressExists(String usernameQuery) async {
    QuerySnapshot user = await _firebaseService.usersRef
        .where('emailAddress', isEqualTo: usernameQuery.trim())
        .get();

    if (user.docs.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  Future<UserDto> getUser(String userId) async {
    DocumentSnapshot user =
        await _firebaseService.usersRef.doc(userId.trim()).get();

    return UserDto.fromJson(user.data() as Map<String, dynamic>);
  }

  @override
  Future<UserDto?> getUserByEmail(String emailAddress) async {
    QuerySnapshot users = await _firebaseService.usersRef
        .where('emailAdress', isEqualTo: emailAddress)
        .get();

    if (users.docs.isNotEmpty) {
      return UserDto.fromJson(users.docs.first.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  @override
  Stream<DocumentSnapshot>? getUserStream(String userId) =>
      _firebaseService.usersRef.doc(userId).snapshots();

  @override
  Future<String> updateProfilePhoto({
    required String userId,
    required String uploadedFile,
  }) async =>
      await _firebaseService.uploadFile(
        UploadPathRef.users,
        fileName: userId,
        uploadedFile: uploadedFile,
      );

  @override
  Future<void> updateUser(
    String documentId, {
    required UserDto updateProfileData,
  }) async =>
      await _firebaseService.usersRef
          .doc(documentId)
          .update(updateProfileData.toJson());

  @override
  Future<void> storeRegisteredUser(
    String documentId, {
    required UserDto registrationData,
  }) async =>
      await _firebaseService.usersRef
          .doc(documentId)
          .set(registrationData.toJson());

  @override
  Stream<QuerySnapshot>? getOrganizations() =>
      _firebaseService.usersRef.where('userRole', isEqualTo: 2).snapshots();
}
