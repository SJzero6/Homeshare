import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';

class OPhoneAuthProvider with ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  String _verificationId = '';
  bool isLoading = false;

  Future<void> sendOtp(String phoneNumber) async {
    isLoading = true;
    notifyListeners();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (fb.PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (fb.FirebaseAuthException e) {
        throw Exception("OTP Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        isLoading = false;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<fb.User?> verifyOtpAndLogin(String otp, String password) async {
    try {
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      final userCredential = await _auth.signInWithCredential(credential);

      // Custom logic to verify password after phone auth

      return userCredential.user;
    } catch (e) {
      throw Exception("Invalid OTP: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
