import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/team_member.dart';
import '../widgets/personnel_list.dart';
import '../team_provider.dart';

class ManagePersonnelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Personnel'),
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
              icon: Icon(Icons.add),
              label: Text('Add Team Member'),
            ),
            SizedBox(height: 16.0),
            PersonnelList(),
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
          title: Text('Add Team Member'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
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
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
