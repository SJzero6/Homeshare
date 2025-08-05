import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';

class OEmailAuthProvider with ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  bool isLoading = false;

  Future<fb.User?> signUp(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      throw Exception("Passwords do not match");
    }

    try {
      isLoading = true;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      return userCredential.user;
    } on fb.FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(_getErrorMessage(e.code));
    }
  }

  Future<fb.User?> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      return userCredential.user;
    } on fb.FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(_getErrorMessage(e.code));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
  // Future<void> checkLoginStatus() async {
  //   _auth.currentUser;
  //   notifyListeners();
  // }
    fb.User? get currentUser => _auth.currentUser;
  /// ✅ Convert Firebase error codes into friendly messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Try signing in instead.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
