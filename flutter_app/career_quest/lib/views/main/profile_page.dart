import 'package:career_quest/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String email = ref.read(userServiceProvider).getUserEmail();
    String name = ref.read(userServiceProvider).getName();
    String? photoURL = ref.read(userServiceProvider).getPhotoURL();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 0),
            leading: CircleAvatar(
              backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
              child: photoURL == null ? const FlutterLogo() : null,
            ),
            title: Text(name),
          ),
          const SizedBox(height: 20),
          const Align(alignment: Alignment.centerLeft, child: Text("Account")),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 0),
            leading: const Icon(Icons.email_outlined),
            title: const Text("Email"),
            subtitle: Text(email),
          ),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 0),
            leading: Icon(Icons.dashboard_customize_outlined),
            title: Text("Personalization"),
          ),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 0),
            leading: Icon(Icons.language_rounded),
            title: Text("Language"),
            subtitle: Text("English"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 0),
            leading: Icon(Icons.logout_rounded, color: Colors.red[300]),
            title: Text(
              "Sign out",
              style: TextStyle(color: Colors.red[300]),
            ),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
