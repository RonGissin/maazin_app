import 'package:flutter/material.dart';
import '../models/team_member.dart';
import '../widgets/generated_lists_widget.dart';
import 'package:provider/provider.dart';
import '../team_provider.dart'; // Import the TeamProvider class
import '../widgets/datetime_picker.dart';

class GeneratedListsScreen extends StatefulWidget {
  @override
  _GeneratedListsScreenState createState() => _GeneratedListsScreenState();
}

class _GeneratedListsScreenState extends State<GeneratedListsScreen> {
  List<String> generatedLists = [];
  List<TeamMember> teamMembers = [];

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
        },),
        SizedBox(height: 16.0),
        DateTimePicker(
          label: 'End Time',
          initialTime: selectedEndTime,
          onTimeChanged: (DateTime time) {
            setState(() {
              selectedEndTime = time;
            });
        },),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Perform list generation logic here
            _generateList(selectedStartTime, selectedEndTime);
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
              ' ${selectedTime.toLocal().hour.toString().padLeft(2, '0')}:${selectedTime.toLocal().minute.toString().padLeft(2, '0')}',
        ),
      ),
    ],
  );
}





void _generateList(DateTime startTime, DateTime endTime) {
    // Implement logic to generate the list based on the selected start and end times
    // ...

    // Dummy logic: Assign each person equal time for guarding
    List<String> newList = [];
    int numberOfMembers = teamMembers.length;
    Duration totalTime = endTime.difference(startTime);
    Duration timePerPerson = totalTime ~/ numberOfMembers;

    for (int i = 0; i < numberOfMembers; i++) {
      DateTime start = startTime.add(timePerPerson * i);
      DateTime end = start.add(timePerPerson);
      String entry = '${teamMembers[i].name}: $start - $end';
      newList.add(entry);
    }

    setState(() {
      generatedLists = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    teamMembers = Provider.of<TeamProvider>(context).teamMembers;

    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Lists'),
      ),
      body: GeneratedListsWidget(generatedLists: generatedLists),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showGenerateListModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
