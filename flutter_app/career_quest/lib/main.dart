import 'package:career_quest/firebase_options.dart';
import 'package:career_quest/providers/providers.dart';
import 'package:career_quest/ui/themes/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: customSwatch,
          brightness: Brightness.dark,
          // textTheme: TextTheme(s)
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: ref.read(routerProvider).router,
      ),
    );
  }
}
