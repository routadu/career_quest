import 'package:career_quest/providers/providers.dart';
import 'package:career_quest/views/main/chat_screen.dart';
import 'package:career_quest/views/main/profile_page.dart';
import 'package:career_quest/views/main/updates_page.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  static const String name = 'home';
  static const String path = '/$name';

  @override
  createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  String response = "Empty Response";
  String query = "What is the capital of Italy ?";

  int currentIndex = 0;

  void onTabChange(int index) {
    currentIndex = index;
    setState(() {});
  }

  void updateQuery(String inp) {
    query = inp;
  }

  void updateResponse(String inp) {
    response = inp;
    setState(() {});
  }

  void callFunction(String query) async {
    HttpsCallable req = FirebaseFunctions.instance.httpsCallable("geminiRes");
    final response = await req.call(<String, dynamic>{"prompt": query});
    if (response.data != null) {
      final map = Map.from(response.data);
      if (map.containsKey("prompt_response")) {
        updateResponse(map["prompt_response"]);
      }
    } else {
      updateResponse("Some error occured");
    }
  }

  void logout() async {
    await ref.read(authServiceProvider).logout();
  }

  Widget getPage() {
    switch (currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const ChatScreen();
      case 2:
        return const UpdatesPage();
      case 3:
        return ProfilePage(onLogout: logout);
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
        child: getPage(),
      ),
      bottomNavigationBar: CustomBottomNavBar(onTabChange: onTabChange),
    ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _getGreetingMessage() {
    var hour = DateTime.now().hour; // Get the current hour
    String message = "";
    if (hour < 12) {
      message += 'Good Morning';
    } else if (hour < 17) {
      message += 'Good Afternoon';
    } else {
      message += 'Good Evening';
    }
    String name = "Aditya";
    message += ",\n";
    message += "$name  😊";
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10),
          Text(
            _getGreetingMessage(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10,
      ),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: GNav(
        activeColor: Theme.of(context).colorScheme.secondary,
        // color: const Color(0xff818286),
        gap: 8,
        tabBackgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        padding: const EdgeInsets.all(15),
        onTabChange: onTabChange,
        tabs: const [
          GButton(
            icon: Icons.home_outlined,
            text: "Home",
          ),
          GButton(
            icon: Icons.search_outlined,
            text: "Search",
          ),
          GButton(icon: Icons.notifications, text: "Updates"),
          GButton(
            icon: Icons.person_outline,
            text: "Profile",
          ),
        ],
      ),
    );
  }
}
