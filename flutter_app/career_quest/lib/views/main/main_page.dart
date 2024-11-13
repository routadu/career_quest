import 'package:career_quest/constants/constants.dart';
import 'package:career_quest/models/question.dart';
import 'package:career_quest/models/quiz.dart';
import 'package:career_quest/models/quiz_result.dart';
import 'package:career_quest/providers/providers.dart';
import 'package:career_quest/views/main/chat_screen.dart';
import 'package:career_quest/views/main/profile_page.dart';
import 'package:career_quest/views/main/quiz_screen.dart';
import 'package:career_quest/views/main/updates_page.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fl_chart/fl_chart.dart';
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
        padding: const EdgeInsets.only(top: 0.0, left: 10, right: 10),
        child: getPage(),
      ),
      bottomNavigationBar: CustomBottomNavBar(onTabChange: onTabChange),
    ));
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
    String name = ref.read(userServiceProvider).getFirstName();
    message += ",\n";
    message += "$name  😊";
    return message;
  }

  void uploadQuizAndResult(Quiz quiz, int score) async {
    Quiz updatedQuiz =
        await ref.read(firestoreServiceProvider).uploadNewQuiz(quiz);
    QuizResult quizResult = QuizResult(
      quizId: updatedQuiz.id,
      timestamp: DateTime.now().toString(),
      totalScore: quiz.questions!.length.toDouble(),
      achievedScore: score.toDouble(),
    );
    await ref.read(firestoreServiceProvider).uploadNewQuizResult(quizResult);
  }

  void playQuiz() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Center(child: Text("Loading quiz")),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
    // await Future.delayed(const Duration(seconds: 5));
    // return;
    final Quiz quiz =
        await ref.read(userServiceProvider).getQuizForCurrentUser();
    debugPrint(quiz.toString());
    List<Question> questions = quiz.questions ?? [];
    ref.read(routerProvider).router.pop();
    final int score = await ref
        .read(routerProvider)
        .router
        .push(QuizScreen.path, extra: questions) as int;
    uploadQuizAndResult(quiz, score);
  }

  @override
  Widget build(BuildContext context) {
    String careerPath = ref.read(userServiceProvider).careerPath;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 15),
          Text(
            _getGreetingMessage(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 80),
          const Text(
            "Your career path",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Text(
            careerPath,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                title: "Play a quiz",
                icon: const Icon(Icons.quiz_outlined),
                onPressed: () {
                  playQuiz();
                },
              ),
              CustomButton(
                title: "Add Record",
                icon: const Icon(Icons.school_outlined),
                secondaryButton: true,
                onPressed: null,
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Text(
            "Your progress",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PerformanceChart(quizResults: kDemoQuizResults),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PerformanceChart extends StatefulWidget {
  final List<QuizResult> quizResults;

  const PerformanceChart({super.key, required this.quizResults});

  @override
  State<PerformanceChart> createState() => _PerformanceChartState();
}

class _PerformanceChartState extends State<PerformanceChart> {
  final double minX = 0, maxX = 5;
  double minY = 0, maxY = 100;

  final List<FlSpot> _spots = [];

  void getSpots() {
    List<QuizResult> finalList;
    int len = widget.quizResults.length;
    if (len >= 6) {
      finalList = widget.quizResults.sublist(len - 6, len);
    } else {
      finalList = widget.quizResults;
    }
    double min = 100;
    double max = 0;
    int index = 0;
    for (QuizResult quizRes in finalList) {
      double score = quizRes.getPercentage();
      min = score < min ? score : min;
      max = score > max ? score : max;
      _spots.add(FlSpot(index.toDouble(), score));
      index++;
    }
    minY = min * 0.9;
    maxY = max * 1.1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSpots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: widget.quizResults.isEmpty
          ? const Center(child: Text("No data available"))
          : LineChart(
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots,
                    isCurved: true,
                    barWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
    );
  }
}

class CustomButton extends StatelessWidget {
  String title;
  Icon icon;
  bool secondaryButton;
  VoidCallback? onPressed;
  double? width, height;

  CustomButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.secondaryButton = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor:
            secondaryButton ? Theme.of(context).colorScheme.tertiary : null,
      ),
      label: SizedBox(
        // width: width ?? MediaQuery.of(context).size.width / 3.5,
        height: height ?? 50,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
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
            text: "Chat",
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
