import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  String? _selectedEducation;
  final List<String> _selectedHobbies = [];

  final List<String> educationLevels = [
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12',
  ];

  final List<String> _hobbies = [
    'Reading',
    'Traveling',
    'Sports',
    'Music',
    'Gaming',
    'Cooking',
    'Art',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  items: educationLevels
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
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: _hobbies.map((hobby) {
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
                ElevatedButton(onPressed: () {}, child: const Text("Continue")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
