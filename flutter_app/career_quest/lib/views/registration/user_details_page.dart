import 'package:career_quest/constants/constants.dart';
import 'package:career_quest/models/user.dart';
import 'package:career_quest/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fA;

class UserDetailsPage extends ConsumerStatefulWidget {
  static const String name = "user_details";
  static const String path = "/$name";

  const UserDetailsPage({super.key});

  @override
  createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final List<String> _selectedHobbies = [];

  String? _selectedEducation;

  bool _isLoading = false;

  createUser() async {
    setState(() {
      _isLoading = true;
    });
    final userProvider = ref.read(userServiceProvider);
    User newUser = User(
      id: userProvider.getUserUid(),
      parentId: "0",
      name: _nameController.text,
      age: int.parse(_ageController.text),
      phone: 9876543210,
      email: userProvider.getUserEmail(),
      educationLevel: _selectedEducation ?? "Class 5",
      interests: _selectedHobbies,
    );
    await ref.read(firestoreServiceProvider).createNewUser(newUser);
    setState(() {
      _isLoading = false;
    });
    navigateToHomeScreen();
  }

  void navigateToHomeScreen() {
    debugPrint("Navigate to homescreen");
    debugPrint(
      "User registered: ${ref.read(authServiceProvider).isUserRegistered}",
    );
    ref.read(routerProvider).router.refresh();
  }

  void initiate() {
    final userProvider = ref.read(userServiceProvider);
    _nameController.text = userProvider.getName();
  }

  @override
  void initState() {
    super.initState();
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 20),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Your information",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 100),
                    TextField(
                      enabled: false,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Education'),
                      value: _selectedEducation,
                      items: kEducationLevels
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEducation = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text('Hobbies'),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4.5,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8.0,
                          children: kHobbies.map((hobby) {
                            final isSelected = _selectedHobbies.contains(hobby);
                            return ChoiceChip(
                              label: Text(hobby),
                              selected: isSelected,
                              selectedColor: Colors.blueAccent,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedHobbies.add(hobby);
                                  } else {
                                    _selectedHobbies.remove(hobby);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: createUser,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
