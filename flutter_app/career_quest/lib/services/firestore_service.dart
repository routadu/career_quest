import 'package:career_quest/models/quiz.dart';
import 'package:career_quest/models/quiz_result.dart';
import 'package:career_quest/models/user.dart' as user;
import 'package:career_quest/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreService {
  static const String kQuizResultKey = 'quizResult';

  ProviderRef<Object?> ref;
  FirebaseFirestore firestore;

  FirestoreService({
    required this.ref,
    required this.firestore,
  });

  Future<bool> userDocumentExists(String uid) async {
    // await firestore
    //     .collection("users")
    //     .doc("WRITE_TEST")
    //     .set({"k1": "v1", "k2": "v2"});
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
    final document = firestore.collection("users").doc(newUser.id);
    await document.set(data);
    await ref
        .read(authServiceProvider)
        .updateRegistrationStatus(override: true);
    await addCareerPathForNewUser(newUser);
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
    final document = firestore.collection("parents").doc(newParentUser.id);
    await document.set(data);
    return user.ParentUser.fromMap(document.id, newParentUser.toMap());
  }

  Future<Quiz> getQuiz(String id) async {
    final docSnap = await firestore.collection('quiz').doc(id).get();
    if (docSnap.exists) {
      return Quiz.fromMap(docSnap.data()!);
    } else {
      return Quiz.empty();
    }
  }

  Future<Quiz> uploadNewQuiz(Quiz quiz) async {
    if (!quiz.isNew) return quiz;
    Map<String, dynamic> data = quiz.toMap();
    data.remove("id");
    final doc = firestore.collection('quiz').doc();
    await doc.set(data);
    data["id"] = doc.id;
    return Quiz.fromMap(data);
  }

  Future<QuizResult> uploadNewQuizResult(QuizResult quizResult) async {
    final currentUser = ref.read(userServiceProvider).currentUser;
    if (currentUser == null) return quizResult;
    Map<String, dynamic> data = quizResult.toMap();
    final doc = firestore.collection('users').doc(currentUser.id);
    await doc.update({
      kQuizResultKey: FieldValue.arrayUnion([data])
    });
    return QuizResult.fromMap(data);
  }

  Future<void> addCareerPathForNewUser(user.User newUser) async {
    String educationLevel = newUser.educationLevel;
    List<String> interests = newUser.interests;

    String careerPathForNewUser =
        await ref.read(geminiServiceProvider).getCareerPath(
              educationLevel,
              interests,
            );

    final doc = firestore.collection('users').doc(newUser.id);
    await doc.update({"careerPath": careerPathForNewUser});
    ref.read(userServiceProvider).careerPath = careerPathForNewUser;
  }

  Future<void> refreshCareerPathForCurrentUser() async {
    user.User? currentUser = ref.read(userServiceProvider).currentUser;
    if (currentUser != null) return await addCareerPathForNewUser(currentUser);
  }
}
