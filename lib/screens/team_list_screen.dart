import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/team_list.dart';
import '../team_provider.dart';

class TeamListScreen extends StatelessWidget {
  const TeamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Team Members',
          style: TextStyle(color: secondaryColor)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _showAddTeamMemberDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Team Member'),
            ),
            const SizedBox(height: 16.0),
            const TeamList(),
          ],
        ),
      ),
    );
  }

  void _showAddTeamMemberDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Team Member'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newMemberName = controller.text.trim();
                if (newMemberName.isNotEmpty) {
                  // Use TeamProvider to add the new team member
                  Provider.of<TeamProvider>(context, listen: false).addTeamMember(newMemberName);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
