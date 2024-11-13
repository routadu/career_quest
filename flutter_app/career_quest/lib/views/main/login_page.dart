import 'package:career_quest/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  static const String name = 'login';
  static const String path = '/$name';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            // const Text("Youtube"),
            SizedBox(height: MediaQuery.of(context).size.height / 4),
            const Text(
              "Career Quest",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Container()),
            LoginButton(
              onPressed: () async => kIsWeb
                  ? await ref.read(authServiceProvider).signInWithGoogleWeb()
                  : await ref.read(authServiceProvider).signInWithGoogle(),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    ));
  }
}

class LoginButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  const LoginButton({super.key, required this.onPressed});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: !_isLoading
          ? SignInButton(
              Buttons.google,
              text: "Continue with Google",
              shape: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.transparent)),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await widget.onPressed();
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            )
          : const CircularProgressIndicator(),
    );
  }
}
