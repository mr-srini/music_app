import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        return 'Wrong email or password';
      }
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      }
      if (e.code == 'wrong-password') {
        return 'Wrong email or password';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static User? currentUser() {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      return firebaseAuth.currentUser;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
