import 'package:career_quest/router/custom_router.dart';
import 'package:career_quest/services/auth_service.dart';
import 'package:career_quest/services/firestore_service.dart';
import 'package:career_quest/services/gemini_service.dart';
import 'package:career_quest/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(
    auth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
    ref: ref,
  ),
);

final firestoreServiceProvider = Provider(
  (ref) => FirestoreService(
    ref: ref,
    firestore: FirebaseFirestore.instance,
  ),
);

final userServiceProvider = Provider((ref) => UserService(ref: ref));

final geminiServiceProvider = Provider((ref) => GeminiService());

final routerProvider = Provider((ref) => CustomRouter(ref: ref));
