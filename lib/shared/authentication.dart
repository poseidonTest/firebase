import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Authentication {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  Future<String> login(String email, String password) async {
    auth.UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    auth.User user = userCredential.user!;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    auth.UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    auth.User user = userCredential.user!;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({"userName": "test", "email": email});
    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<auth.User?> getUser() async {
    auth.User? user = _firebaseAuth.currentUser;
    return user;
  }
}
