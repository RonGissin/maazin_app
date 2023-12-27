import 'package:flutter/material.dart';
import '../team_provider.dart';
import '../models/team_member.dart';
import 'package:provider/provider.dart';


class AddTeamMemberDialog extends StatefulWidget {
  final List<TeamMember> teamMembers;

  const AddTeamMemberDialog({Key? key, required this.teamMembers}) : super(key: key);

  @override
  _AddTeamMemberDialogState createState() => _AddTeamMemberDialogState();
}

class _AddTeamMemberDialogState extends State<AddTeamMemberDialog> {
  TextEditingController _controller = TextEditingController();
  bool _showEmptyError = false;
  bool _showNameExistsError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Team Member'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 8.0),
          Text(
            _showEmptyError
                ? 'Please enter a valid input'
                : _showNameExistsError
                    ? 'Please enter a non-existing name'
                    : '',
            style: TextStyle(color: Colors.red),
          ),
        ],
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
            String newMemberName = _controller.text.trim();
            String lowerCaseMemberName = newMemberName.toLowerCase();

            setState(() {
              _showEmptyError = newMemberName.isEmpty;
              _showNameExistsError =
                  newMemberName.isNotEmpty && widget.teamMembers.map((e) => e.name.toLowerCase()).contains(lowerCaseMemberName);
            });

            if (!_showEmptyError && !_showNameExistsError) {
              // Use TeamProvider to add the new team member
              Provider.of<TeamProvider>(context, listen: false).addTeamMember(newMemberName);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
