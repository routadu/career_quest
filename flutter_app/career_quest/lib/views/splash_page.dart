import 'package:career_quest/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  static const String name = 'splash_page';
  static const String path = '/';

  @override
  createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  void navigate() async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    ref.read(routerProvider).router.refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: Center(
        child: Text("Career Quest"),
      ),
    ));
  }
}
