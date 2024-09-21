import 'dart:async';

import 'package:career_quest/providers/providers.dart';
import 'package:career_quest/services/auth_service.dart';
import 'package:career_quest/views/main/main_page.dart';
import 'package:career_quest/views/main/login_page.dart';
import 'package:career_quest/views/registration/email_verify_page.dart';
import 'package:career_quest/views/registration/parentuser_details_page.dart';
import 'package:career_quest/views/registration/user_details_page.dart';
import 'package:career_quest/views/splash_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomRouter {
  final ProviderRef<Object?> ref;
  late GoRouter router;
  late StreamSubscription<User?> authStateSubscription;

  CustomRouter({required this.ref}) {
    setupRouter();
    authStateSubscription = ref
        .read(authServiceProvider)
        .stream
        .listen((User? user) => debugPrint("customrouter stream subscription")
            // router.refresh()
            );
  }

  void setupRouter() {
    router = GoRouter(
      initialLocation: SplashPage.path,
      routes: [
        GoRoute(
          name: SplashPage.name,
          path: SplashPage.path,
          pageBuilder: (context, state) =>
              const MaterialPage(child: SplashPage()),
        ),
        GoRoute(
          name: MainPage.name,
          path: MainPage.path,
          pageBuilder: (context, state) =>
              const MaterialPage(child: MainPage()),
        ),
        GoRoute(
          name: LoginPage.name,
          path: LoginPage.path,
          pageBuilder: (context, state) =>
              const MaterialPage(child: LoginPage()),
        ),
        GoRoute(
          name: EmailVerifyPage.name,
          path: EmailVerifyPage.path,
          pageBuilder: (context, state) =>
              const MaterialPage(child: EmailVerifyPage()),
        ),
        GoRoute(
          name: UserDetailsPage.name,
          path: UserDetailsPage.path,
          pageBuilder: (context, state) =>
              const MaterialPage(child: UserDetailsPage()),
        ),
        GoRoute(
          name: ParentuserDetailsPage.name,
          path: ParentuserDetailsPage.path,
          pageBuilder: (context, state) =>
              const MaterialPage(child: ParentuserDetailsPage()),
        ),
      ],
      redirect: (context, state) async {
        AuthService authService = ref.read(authServiceProvider);
        if (authService.isUserAuthenticated) {
          // return MainPage.path;
          // return RegistrationFlowPage.path;
          if (!authService.isUserEmailVerified) {
            return EmailVerifyPage.path;
          } else if (!authService.isUserRegistered) {
            return UserDetailsPage.path;
          } else {
            return MainPage.path;
          }
        } else {
          return LoginPage.path;
        }
      },
    );
  }

  void close() async {
    await authStateSubscription.cancel();
  }
}
