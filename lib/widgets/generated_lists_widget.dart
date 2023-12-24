import 'package:flutter/material.dart';

class GeneratedListsWidget extends StatelessWidget {
  final List<String> generatedLists;

  GeneratedListsWidget({required this.generatedLists});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: generatedLists.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(generatedLists[index]),
          // Add more details or actions as needed
        );
      },
    );
  }
}
