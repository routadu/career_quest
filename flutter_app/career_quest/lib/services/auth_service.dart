import 'dart:async';

import 'package:career_quest/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  ProviderRef<Object?> ref;
  FirebaseAuth auth;
  GoogleSignIn googleSignIn;
  UserCredential? firebaseUserCredential;
  late Stream<User?> stream;
  late StreamSubscription subscription;

  AuthService({
    required this.auth,
    required this.googleSignIn,
    required this.ref,
  }) {
    stream = auth.authStateChanges();
    subscription = stream.listen(streamListener);
  }

  bool _isUserRegistered = false;

  User? get user => auth.currentUser;
  bool get isUserAuthenticated => user != null;
  bool get isUserEmailVerified => user?.emailVerified ?? false;
  bool get isUserRegistered => _isUserRegistered;

  void streamListener(User? user) async {
    await user?.reload();
    _isUserRegistered = await _updateRegistrationStatus();
    ref.read(routerProvider).router.refresh();
  }

  Future<bool> _updateRegistrationStatus() async {
    return auth.currentUser == null
        ? false
        : ref
            .read(firestoreServiceProvider)
            .userDocumentExists(auth.currentUser!.uid);
  }

  Future reloadUser() async {
    await user?.reload();
  }

  Future sendEmailVerificationLink() async {
    if (!isUserAuthenticated) return;
    await auth.currentUser?.sendEmailVerification();
    await auth.currentUser?.reload();
  }

  Future signInWithGoogleWeb() async {
    final authProvider = GoogleAuthProvider();
    firebaseUserCredential = await auth.signInWithPopup(authProvider);
  }

  Future signInWithGoogle() async {
    final googleAccount = await googleSignIn.signIn();
    final authentication = await googleAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );
    firebaseUserCredential = await auth.signInWithCredential(credential);
  }

  Future logout() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }

  void cancelSubscription() {
    subscription.cancel();
  }
}
