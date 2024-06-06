import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
  /// Register user. Returns [UserCredential].
  Future<UserCredential>? registerUser({
    required String emailAddress,
    required String password,
  });

  /// Login user. Returns [UserCredential].
  Future<UserCredential>? login({
    required String email,
    required String password,
  });

  /// Change user's password.
  Future<void> changePassword(String newPassword);

  /// Change user's current password.
  Future<UserCredential>? checkCurrentPassword(String currentPassword);

  /// Sign out user's current session.
  Future<void> signOut();
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl(this._firebaseService);

  // ignore: unused_field
  final FirebaseService? _firebaseService;

  @override
  Future<void> changePassword(String newPassword) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
  }

  @override
  Future<UserCredential>? checkCurrentPassword(String currentPassword) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: FirebaseAuth.instance.currentUser!.email!,
      password: currentPassword,
    );

    UserCredential? userCredential =
        await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
      credential,
    );

    return userCredential!;
  }

  @override
  Future<UserCredential>? login({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential;
  }

  @override
  Future<UserCredential>? registerUser({
    required String emailAddress,
    required String password,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    return userCredential;
  }

  @override
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}
