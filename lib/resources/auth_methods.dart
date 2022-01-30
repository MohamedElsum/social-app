import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:social_app/resources/storage_methods.dart';
import 'package:social_app/models/users.dart' as model;

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User currentUser = auth.currentUser!;
    DocumentSnapshot snap = await firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signupUser(
      {required String email,
      required String bio,
      required String password,
      required String username,
      required File? file}) async {
    String res = 'Some Error Occurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty &&
          file != null) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String imageUrl = await StorageMethods().uploadImageToStorage(
            childName: 'profilePics', isPost: false, file: file);

        model.User user = model.User(
          username: username,
          bio: bio,
          email: email,
          photoUrl: imageUrl,
          uid: cred.user!.uid,
          followers: [],
          following: [],
        );

        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'Please enter a valid email';
      } else if (err.code == 'weak-password') {
        res = 'Your password must be more than 6 characters';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = 'This email is not found!!';
      } else if (err.code == 'wrong-password') {
        res = 'Wrong Password Please try again';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signout() async{
    await auth.signOut();
  }
}
