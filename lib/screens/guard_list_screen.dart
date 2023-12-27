import 'package:flutter/material.dart';
import '../widgets/generate_list_modal.dart'; // Import the GenerateListModal class
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
  const GuardListScreen({Key? key}) : super(key: key);

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
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();
  bool isInvalidTime = false;
  int? intGuardTime;
  TextEditingController doubleGuardTimeController = TextEditingController();
  bool isFixedGuardTime = false;

  @override
  bool get wantKeepAlive => true;

  void _showGenerateListModal(
      BuildContext context, DateTime previousStartTime, DateTime previousEndTime) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GenerateListModal(
          onGenerateList: _generateList, // Pass the callback function
          previousStartTime: previousStartTime,
          previousEndTime: previousEndTime,
        );
      },
    );
  }

  Widget _buildGenerateListModal(
      BuildContext context, DateTime previousStartTime, DateTime previousEndTime) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Start Time and End Time',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          DateTimePicker(
            label: 'Start Time',
            initialTime: previousStartTime,
            onTimeChanged: (DateTime time) {
              setState(() {
                selectedStartTime = time;
              });
            },
          ),
          const SizedBox(height: 10.0),
          DateTimePicker(
            label: 'End Time',
            initialTime: previousEndTime,
            onTimeChanged: (DateTime time) {
              setState(() {
                selectedEndTime = time;
                isInvalidTime = selectedStartTime.isAfter(selectedEndTime);
              });
            },
          ),
          const SizedBox(height: 10.0),
          Visibility(
            visible: isInvalidTime,
            child: Text(
              'End time cannot be earlier than start time',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 10.0),
          NumberOfGuardsInput(
            initialState: numberOfConcurrentGuards,
            onChanged: (value) {
              setState(() {
                numberOfConcurrentGuards = value;
              });
            },
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Switch( // Change Checkbox to Switch
                value: isFixedGuardTime,
                onChanged: (value) {
                  setState(() {
                    isFixedGuardTime = value;
                  });
                },
              ),
              Text('Fixed Guard Time'),
            ],
          ),
          Visibility(
            visible: isFixedGuardTime,
            child: TextField(
              controller: doubleGuardTimeController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  intGuardTime = int.tryParse(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Guard Time in minutes - optional',
                hintText: 'Enter guard time in minutes',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
            onPressed: () {
              setState(() {
                isInvalidTime = selectedStartTime.isAfter(selectedEndTime);
              });
              // Perform validation
              if (isInvalidTime) {
                return;
              }

              // Perform list generation logic here
              setState(() {
                guardGroups = generator.generateGuardGroups(
                  teamMembers,
                  numberOfConcurrentGuards,
                  selectedStartTime,
                  selectedEndTime,
                  isFixedGuardTime ? intGuardTime : null,
                );
              });
              Navigator.pop(context); // Close the modal
            },
            child: const Text('Generate'),
          )),
        ],
      ),
    );
  }

  void _generateList(
    DateTime startTime,
    DateTime endTime,
    int? guardTime,
    int numberOfConcurrentGuards,
    bool isFixedGuardTime, // Add this parameter
  ) {
    setState(() {
      isInvalidTime = startTime.isAfter(endTime);
    });

    // Perform validation
    if (isInvalidTime) {
      return;
    }

    // Perform list generation logic here
    setState(() {
      guardGroups = generator.generateGuardGroups(
        teamMembers,
        numberOfConcurrentGuards,
        startTime,
        endTime,
        isFixedGuardTime ? guardTime : null,
      );
    });
    Navigator.pop(context); // Close the modal
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
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
          'Guard List',
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: guardGroupsList,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: guardGroupsList.getReadableList()));
                _showSnackBar(context, 'Copied!');
              },
              child: const Icon(Icons.copy),
            ),
          ),
          FloatingActionButton(
              onPressed: () {
                _showGenerateListModal(context,
                    _calculatePresentionTime(selectedStartTime),
                    _calculatePresentionTime(selectedEndTime));
              },
              child: const Icon(Icons.edit)),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  DateTime _calculatePresentionTime(DateTime startTime) {
    return startTime.difference(DateTime.now()) < Duration.zero
        ? DateTime.now()
        : startTime;
  }
}
