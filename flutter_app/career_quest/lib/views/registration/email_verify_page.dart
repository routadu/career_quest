import 'package:career_quest/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

class EmailVerifyPage extends ConsumerStatefulWidget {
  const EmailVerifyPage({super.key});

  static const String name = 'email_verification';
  static const String path = '/$name';

  @override
  createState() {
    return _EmailVerifyPageState();
  }
}

class _EmailVerifyPageState extends ConsumerState<EmailVerifyPage> {
  bool isLoading = false;

  void sendEmailVerificationLink() async {
    await ref.read(authServiceProvider).sendEmailVerificationLink();
    toastification.show(title: const Text("Verification email sent"));
  }

  void processVerification() async {
    setState(() {
      isLoading = true;
    });
    await ref.read(authServiceProvider).reloadUser();
    setState(() {
      isLoading = false;
    });
    if (ref.read(authServiceProvider).isUserEmailVerified) {
      ref.read(routerProvider).router.refresh();
    } else {
      toastification.show(title: const Text("Email not verified yet"));
    }
  }

  @override
  void initState() {
    super.initState();
    sendEmailVerificationLink();
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.read(userServiceProvider).getUserEmail();
    return SafeArea(
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 4),
          const Icon(Icons.email_outlined, size: 60),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Verify your email address",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(height: 60),
          Text("We have sent a verification email to $email"),
          Expanded(child: Container()),
          TextButton(
            onPressed: processVerification,
            child: !isLoading
                ? const Text("Continue")
                : const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      )),
    );
  }
}
