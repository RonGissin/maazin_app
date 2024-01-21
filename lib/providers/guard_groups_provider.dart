import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assigned_team_member.dart';

class GuardGroupsProvider extends ChangeNotifier {
  List<List<AssignedTeamMember>> _guardGroups = [];

  List<List<AssignedTeamMember>> get guardGroups => _guardGroups;

  Future<void> init() async {
    await loadGuardGroups();
  }

  Future<void> loadGuardGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedGuardGroupsJson = prefs.getString('guardGroups');

    if (savedGuardGroupsJson != null) {
      List<dynamic> savedGuardGroupsList = json.decode(savedGuardGroupsJson);
      _guardGroups = savedGuardGroupsList.map((group) {
        List<dynamic> groupList = group as List<dynamic>;
        return groupList.map((memberJson) {
          Map<String, dynamic> memberMap = memberJson as Map<String, dynamic>;
          return AssignedTeamMember(
            memberMap['name'] as String,
            true,
            DateTime.parse(memberMap['startTime'] as String),
            DateTime.parse(memberMap['endTime'] as String),
          );
        }).toList();
      }).toList();
      notifyListeners();
    }
  }

  void saveGuardGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> guardGroupsMapList = _guardGroups
        .map((group) => group
            .map((member) => {
                  'name': member.name,
                  'startTime': member.startTime.toIso8601String(),
                  'endTime': member.endTime.toIso8601String(),
                })
            .toList())
        .toList();
    String guardGroupsJson = json.encode(guardGroupsMapList);
    prefs.setString('guardGroups', guardGroupsJson);
  }

  void updateGuardGroups(List<List<AssignedTeamMember>> newGuardGroups) {
    _guardGroups = newGuardGroups;
    saveGuardGroups();
    notifyListeners();
  }
}
