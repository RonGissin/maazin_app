import 'package:flutter/material.dart';
import 'package:maazin_app/widgets/generate_list_modal.dart'; // Import the GenerateListModal class
import 'package:maazin_app/guard_list_generator.dart';
import 'package:maazin_app/models/assigned_team_member.dart';
import 'package:maazin_app/models/team_member.dart';
import 'package:maazin_app/widgets/guard_groups_list.dart';
import 'package:provider/provider.dart';
import 'package:maazin_app/team_provider.dart'; // Import the TeamProvider class
import 'package:flutter/services.dart';
import 'package:share/share.dart'; // Import the share package

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
      BuildContext context,
      DateTime previousStartTime,
      DateTime previousEndTime,
      void Function(DateTime) onSetStartTime,
      void Function(DateTime) onSetEndTime) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: GenerateListModal(
            onGenerateList: _generateList, // Pass the callback function
            previousStartTime: previousStartTime,
            previousEndTime: previousEndTime,
            onSetStartTime: onSetStartTime,
            onSetEndTime: onSetEndTime,
        ));
      },
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
                final String readableList = guardGroupsList.getReadableList();
                Share.share(readableList);
              },
              child: const Icon(Icons.share_sharp),
            ),
          ),
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
                _showGenerateListModal(
                    context,
                    selectedStartTime,
                    selectedEndTime,
                    (time) => setState(() => selectedStartTime = time),
                    (time) => setState(() => selectedEndTime = time));
              },
              child: const Icon(Icons.edit)),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
