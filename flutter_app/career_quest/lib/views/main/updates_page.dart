import 'package:flutter/material.dart';

class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key});

  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  List<Object> updates = [];

  @override
  Widget build(BuildContext context) {
    return updates.isNotEmpty
        ? ListView.builder(
            itemCount: updates.length,
            itemBuilder: (context, index) {
              return Container();
            },
          )
        : const Center(
            child: Text("No updates available"),
          );
  }
}
