import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/team_member.dart';

class TeamProvider extends ChangeNotifier {
  List<TeamMember> _teamMembers = [];

  List<TeamMember> get teamMembers => _teamMembers;

  // Initialize the state by loading team members from SharedPreferences
  Future<void> init() async {
    await loadTeamMembers();
  }

  // Load team members from SharedPreferences
  Future<void> loadTeamMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTeamMembers = prefs.getStringList('teamMembers');

    if (savedTeamMembers != null) {
      _teamMembers = savedTeamMembers.map((name) => TeamMember(name: name)).toList();
      notifyListeners();
    }
  }

  // Add a new team member
  void addTeamMember(String newMemberName) {
    _teamMembers.add(TeamMember(name: newMemberName));
    _saveTeamMembers();
  }

  // Remove a team member
  void removeTeamMember(int index) {
    _teamMembers.removeAt(index);
    _saveTeamMembers();
  }

  void editTeamMember(String existingMemberName, String newMemberName) {
    _teamMembers.forEach((tm) {
      if (tm.name.toLowerCase() == existingMemberName.toLowerCase()) {
        tm.name = newMemberName;
      }
    });
    _saveTeamMembers();
  }

  // Save team members to SharedPreferences
  void _saveTeamMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('teamMembers', _teamMembers.map((member) => member.name).toList());
    notifyListeners();
  }
}
