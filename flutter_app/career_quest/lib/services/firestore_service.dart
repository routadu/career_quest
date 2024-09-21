import 'package:career_quest/models/user.dart' as user;
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreService {
  ProviderRef<Object?> ref;
  FirebaseFirestore firestore;

  FirestoreService({
    required this.ref,
    required this.firestore,
  });

  Future<bool> userDocumentExists(String uid) async {
    return (await firestore.collection("users").doc(uid).get()).exists;
  }

  Future<user.User> getCurrentUser(fauth.User firebaseUser) async {
    final document =
        await firestore.collection("users").doc(firebaseUser.uid).get();
    if (document.exists) {
      return user.User.fromMap(firebaseUser.uid, document.data() ?? {});
    } else {
      return user.User.empty();
    }
  }

  Future<user.User> createNewUser(user.User newUser) async {
    final data = newUser.toMap();
    data.remove("id");
    final document = await firestore.collection("users").add(data);
    return user.User.fromMap(document.id, newUser.toMap());
  }

  Future<user.ParentUser> getParentUser(fauth.User firebaseUser) async {
    final document =
        await firestore.collection("parents").doc(firebaseUser.uid).get();
    if (document.exists) {
      return user.ParentUser.fromMap(firebaseUser.uid, document.data() ?? {});
    } else {
      return user.ParentUser.empty();
    }
  }

  Future<user.ParentUser> createNewParentUser(
      user.ParentUser newParentUser) async {
    final data = newParentUser.toMap();
    data.remove("id");
    final document = await firestore.collection("parents").add(data);
    return user.ParentUser.fromMap(document.id, newParentUser.toMap());
  }
}
