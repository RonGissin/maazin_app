import 'dart:convert'; // Import the dart:convert library
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/team_member.dart';
import 'package:flutter/widgets.dart';

class TeamProvider extends ChangeNotifier with WidgetsBindingObserver{
  List<TeamMember> _teamMembers = [];

  List<TeamMember> get teamMembers => _teamMembers;

  // Initialize the state by loading team members from SharedPreferences
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await loadTeamMembers();
  }

  // Dispose the observer when the provider is no longer needed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    saveTeamMembers();
    super.dispose();
  }

  // Called when the app is paused or detached (e.g., when closing the app)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    saveTeamMembers();
  }

  // Load team members from SharedPreferences
  Future<void> loadTeamMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTeamMembersJson = prefs.getString('teamMembers');

    if (savedTeamMembersJson != null) {
      // Decode JSON string to List<dynamic>
      List<dynamic> savedTeamMembersList = json.decode(savedTeamMembersJson);

      // Convert List<dynamic> to List<TeamMember>
      _teamMembers = savedTeamMembersList
          .map((item) => TeamMember(name: item['name'], isEnabled: item['isEnabled']))
          .cast<TeamMember>() // Add cast to TeamMember
          .toList();

      notifyListeners();
    }
  }

  // Add a new team member
  void addTeamMember(String newMemberName) {
    _teamMembers.insert(0, TeamMember(name: newMemberName, isEnabled: true));
    saveTeamMembers();
  }

  // Remove a team member
  void removeTeamMember(int index) {
    _teamMembers.removeAt(index);
    saveTeamMembers();
  }

  void editTeamMember(String existingMemberName, String newMemberName) {
    _teamMembers.forEach((tm) {
      if (tm.name.toLowerCase() == existingMemberName.toLowerCase()) {
        tm.name = newMemberName;
      }
    });
    saveTeamMembers();
  }

  // Save team members to SharedPreferences
  void saveTeamMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert List<TeamMember> to List<Map<String, dynamic>>
    List<Map<String, dynamic>> teamMembersMapList =
        _teamMembers.map((member) => {'name': member.name, 'isEnabled': member.isEnabled}).toList();

    // Encode List<Map<String, dynamic>> to JSON string
    String teamMembersJson = json.encode(teamMembersMapList);

    prefs.setString('teamMembers', teamMembersJson);
    notifyListeners();
  }
}