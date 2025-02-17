import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore

class FirebaseAuthService {
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Sign in with email & password (FirebaseAuth)
  Future<User?> signIn({String? email, String? password}) async {
    try {
      UserCredential ucred = await _fbAuth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      User? user = ucred.user;
      debugPrint("Sign in successful! userid: ${user?.uid}, user: $user.");
      return user!;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return null;
    }
  }

  // Sign up with email & password (FirebaseAuth)
  // Also store user doc in Firestore under "users/<uid>" with plain-text email/password
  Future<User?> signUp({String? email, String? password}) async {
    try {
      UserCredential ucred = await _fbAuth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      User? user = ucred.user;
      debugPrint('Signed up successfully! user: $user');

      // Create Firestore doc with plain-text email/password
      if (user != null) {
        final docRef = usersCollection.doc(user.uid);
        await docRef.set({
          'uid': user.uid,
          'email': email,
          'password': password, // Plain-text password (NOT recommended in production!)
        });
        debugPrint('User doc added to Firestore: ${docRef.id}');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return null;
    }
  }

  // Sign out from FirebaseAuth
  Future<void> signOut() async {
    await _fbAuth.signOut();
  }

  // Update the user doc in Firestore ONLY (does NOT change Auth credentials)
  Future<void> updateUserDoc({
    required String uid,
    required String newEmail,
    required String newPassword,
  }) async {
    final docRef = usersCollection.doc(uid);
    await docRef.update({
      'email': newEmail,
      'password': newPassword,
    });
    debugPrint('Updated Firestore doc for uid: $uid');
  }
}
