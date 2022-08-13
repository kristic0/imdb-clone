import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:imdb_clone/env_conf.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountService {
  AccountService();

  static Future createUser({required String email, required String pwd}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final creds = {'email': email, 'password': pwd};

    await docUser.set(creds);
  }

  static Future<Map<String, dynamic>> getUserData(String uid) async {
    var userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      userData = data;
    });

    return userData;
  }

  static Future<User?> register(
      {required String email,
      required String password,
      required String name}) async {}

  static Future<User?> login(
      {required String email, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No User found");
      }
    }

    return user;
  }
}
