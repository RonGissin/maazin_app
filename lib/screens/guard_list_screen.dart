import 'package:flutter/material.dart';
import 'package:maazin_app/guard_list_generator.dart';
import 'package:maazin_app/models/assigned_team_member.dart';
import '../models/team_member.dart';
import '../widgets/guard_groups_list.dart';
import 'package:provider/provider.dart';
import '../team_provider.dart'; // Import the TeamProvider class
import '../widgets/datetime_picker.dart';
import '../widgets/number_of_guards_input.dart';
import 'package:flutter/services.dart';

class GuardListScreen extends StatefulWidget {
  const GuardListScreen({super.key});

  @override
  _GuardListScreenState createState() => _GuardListScreenState();
}

class _GuardListScreenState extends State<GuardListScreen> 
  with AutomaticKeepAliveClientMixin {
  List<List<AssignedTeamMember>> guardGroups = [];
  List<TeamMember> teamMembers = [];
  GuardListGenerator generator = GuardListGenerator();
  int numberOfConcurrentGuards = 1;
  late GuardGroupsList guardGroupsList;

  @override
  bool get wantKeepAlive => true;

  void _showGenerateListModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _buildGenerateListModal(context);
      },
    );
  }

Widget _buildGenerateListModal(BuildContext context) {
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();

  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Start Time and End Time',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        DateTimePicker(
          label: 'Start Time',
          initialTime: selectedStartTime,
          onTimeChanged: (DateTime time) {
            setState(() {
              selectedStartTime = time;
            });
          },
        ),
        const SizedBox(height: 16.0),
        DateTimePicker(
          label: 'End Time',
          initialTime: selectedEndTime,
          onTimeChanged: (DateTime time) {
            setState(() {
              selectedEndTime = time;
            });
          },
        ),
         const SizedBox(height: 16.0),
        NumberOfGuardsInput(
          onChanged: (value) {
            setState(() {
              numberOfConcurrentGuards = value;
            });
          },
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Perform list generation logic here
            setState(() {
              guardGroups = generator.generateGuardGroups(
                teamMembers,
                numberOfConcurrentGuards,
                selectedStartTime,
                selectedEndTime,
              );
            });
            Navigator.pop(context); // Close the modal
          },
          child: const Text('Generate'),
        ),
      ],
    ),
  );
}

void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.only(bottom: 25.0), // Adjust bottom padding as needed
          child: Center(child: Text(message)),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.fixed,
        elevation: 30,
      ),
    );
  }

@override
Widget build(BuildContext context) {
    super.build(context);
    
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    teamMembers = Provider.of<TeamProvider>(context).teamMembers;
    guardGroupsList = GuardGroupsList(guardGroups: guardGroups);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Team Members',
          style: TextStyle(color: secondaryColor)
        ),
      ),
      body: guardGroupsList,
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () {
      //    _showGenerateListModal(context);
      //  },
      //  child: Icon(Icons.edit),
      //),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FloatingActionButton(
            onPressed: () {
              // Handle second FAB press
              Clipboard.setData(ClipboardData(text: guardGroupsList.getReadableList()));
              _showSnackBar(context, 'Copied!');
            },
            child: const Icon(Icons.copy),
          ),),
          
          FloatingActionButton(
            onPressed: () {
              _showGenerateListModal(context);
            },
            child: const Icon(Icons.edit)
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
