import 'package:career_quest/models/question.dart';
import 'package:career_quest/models/quiz.dart';
import 'package:career_quest/models/user.dart';
import 'package:career_quest/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;

class UserService {
  ProviderRef<Object?> ref;

  UserService({required this.ref});

  User? currentUser;
  ParentUser? parentUser;

  String getUserUid() {
    return ref.read(authServiceProvider).auth.currentUser?.uid ?? "";
  }

  String getParentUid() {
    return parentUser?.id ?? "";
  }

  String getUserEmail() {
    if (currentUser != null) return currentUser!.email;
    return ref.read(authServiceProvider).auth.currentUser?.email ?? "";
  }

  String getName() {
    // if (currentUser != null) return currentUser!.name;
    return ref.read(authServiceProvider).auth.currentUser?.displayName ?? "";
  }

  String getFirstName() {
    return getName().split(' ').first;
  }

  String? getPhotoURL() {
    return ref.read(authServiceProvider).auth.currentUser?.photoURL;
  }

  String get careerPath => currentUser?.careerPath ?? "Fetch now";

  set careerPath(path) => currentUser?.careerPath = path;

  Future<Quiz> getQuizForCurrentUser() async {
    if (currentUser == null) return Quiz(id: "0");
    return ref.read(geminiServiceProvider).getQuizQuestions(
          currentUser!.educationLevel,
          currentUser!.interests,
        );
  }

  void updateUser(fAuth.User? firebaseUser) async {
    if (firebaseUser == null) return;
    currentUser =
        await ref.read(firestoreServiceProvider).getCurrentUser(firebaseUser);
    parentUser =
        await ref.read(firestoreServiceProvider).getParentUser(firebaseUser);
  }

  void createNewUser(User user, ParentUser parentUser) {}

  void updateCurrentUser(User user) {
    currentUser = user;
  }

  void updateParentUser(ParentUser user) {
    parentUser = user;
  }
}
