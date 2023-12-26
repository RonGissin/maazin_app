import 'package:flutter/material.dart';
import 'package:maazin_app/guard_list_generator.dart';
import 'package:maazin_app/models/assigned_team_member.dart';
import '../models/team_member.dart';
import '../widgets/guard_groups_list.dart';
import 'package:provider/provider.dart';
import '../team_provider.dart'; // Import the TeamProvider class
import '../widgets/datetime_picker.dart';
import '../date_formatter.dart';
import '../widgets/number_of_guards_input.dart';
import 'package:flutter/services.dart';

class GeneratedListsScreen extends StatefulWidget {
  @override
  _GeneratedListsScreenState createState() => _GeneratedListsScreenState();
}

class _GeneratedListsScreenState extends State<GeneratedListsScreen> 
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
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Start Time and End Time',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        DateTimePicker(
          label: 'Start Time',
          initialTime: selectedStartTime,
          onTimeChanged: (DateTime time) {
            setState(() {
              selectedStartTime = time;
            });
          },
        ),
        SizedBox(height: 16.0),
        DateTimePicker(
          label: 'End Time',
          initialTime: selectedEndTime,
          onTimeChanged: (DateTime time) {
            setState(() {
              selectedEndTime = time;
            });
          },
        ),
         SizedBox(height: 16.0),
        NumberOfGuardsInput(
          onChanged: (value) {
            setState(() {
              numberOfConcurrentGuards = value;
            });
          },
        ),
        SizedBox(height: 16.0),
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
          child: Text('Generate'),
        ),
      ],
    ),
  );
}

Widget _buildDateTimePicker({
  required String label,
  required DateTime selectedTime,
  required ValueChanged<DateTime> onTimeChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16.0),
      ),
      SizedBox(height: 8.0),
      ElevatedButton(
        onPressed: () async {
          DateTime? pickedDateTime = await showDatePicker(
            context: context,
            initialDate: selectedTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );

          if (pickedDateTime != null) {
            TimeOfDay? pickedHourMinute = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(selectedTime),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );

            if (pickedHourMinute != null) {
              DateTime selectedDateTime = DateTime(
                pickedDateTime.year,
                pickedDateTime.month,
                pickedDateTime.day,
                pickedHourMinute.hour,
                pickedHourMinute.minute,
              );

              // Update the selectedTime within the function
              selectedTime = selectedDateTime;

              onTimeChanged(selectedDateTime);
            }
          }
        },
        child: Text(
          '${selectedTime.toLocal()}'.split(' ')[0] +
              ' ${DateFormatter.formatTime(selectedTime)}',
        ),
      ),
    ],
  );
}

void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

@override
Widget build(BuildContext context) {
    teamMembers = Provider.of<TeamProvider>(context).teamMembers;
    guardGroupsList = GuardGroupsList(guardGroups: guardGroups);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Guard List'),
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
            child: Icon(Icons.copy),
          ),),
          
          FloatingActionButton(
            onPressed: () {
              _showGenerateListModal(context);
            },
            child: Icon(Icons.edit)
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
