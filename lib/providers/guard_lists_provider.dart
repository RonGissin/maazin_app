import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assigned_team_member_model.dart';
import '../models/guard_list_model.dart';

class GuardListsProvider extends ChangeNotifier {
  List<GuardListModel> _guardLists = [];
  List<GuardListModel> get guardLists => _guardLists;

  Future<void> init() async {
    await loadGuardLists();
  }

  Future<void> loadGuardLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedGuardListsJson = prefs.getString('guardLists');

    if (savedGuardListsJson != null) {
      List<dynamic> savedGuardListsDynamic = json.decode(savedGuardListsJson);
      List<Map<String, dynamic>> savedGuardLists = List<Map<String, dynamic>>.from(savedGuardListsDynamic);
      
      _guardLists = savedGuardLists.map((list) {
        String name = list['name'] as String;
        List<dynamic> guardGroupsDynamic = list['guardGroups'] as List;
        List<List<AssignedTeamMemberModel>> guardGroups = guardGroupsDynamic.map((groupDynamic) {
          List<Map<String, dynamic>> group = List<Map<String, dynamic>>.from(groupDynamic);
          return group.map((memberJson) {
            return AssignedTeamMemberModel(
              memberJson['name'] as String,
              true, // Assuming this field exists in AssignedTeamMember
              DateTime.parse(memberJson['startTime'] as String),
              DateTime.parse(memberJson['endTime'] as String),
            );
          }).toList();
        }).toList();
        return GuardListModel(name: name, guardGroups: guardGroups); // Ensure GuardList is a valid constructor
      }).toList();
      
      notifyListeners();
    }
  }

  void addGuardList(GuardListModel newList) {
    guardLists.add(newList);
    saveGuardLists();
    notifyListeners();
  }

  // Remove a team member
  void removeList(int index) {
    guardLists.removeAt(index);
    saveGuardLists();
    notifyListeners();
  }

  void saveGuardLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> guardListsMap = guardLists.map((listInfo) {
      return {
        'name': listInfo.name,
        'guardGroups': listInfo.guardGroups.map((group) {
          return group.map((member) {
            return {
              'name': member.name,
              'startTime': member.startTime.toIso8601String(),
              'endTime': member.endTime.toIso8601String(),
            };
          }).toList();
        }).toList(),
      };
    }).toList();

    String guardListsJson = json.encode(guardListsMap);
    prefs.setString('guardLists', guardListsJson);
  }

  void clearGuardLists() async {
    // Clear the in-memory representation of the guard lists
    _guardLists.clear();

    // Clear the guard lists from persistent storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('guardLists');

    // Notify all listening widgets to rebuild based on the updated state
    notifyListeners();
  }

  void updateGuardList(String listName, List<List<AssignedTeamMemberModel>> newGuardGroups) {
    var list = guardLists.firstWhere((element) => element.name == listName);
    list.guardGroups = newGuardGroups;
    saveGuardLists();
    notifyListeners();
  }

  void renameGuardList(String listName, String newName) {
    var list = guardLists.firstWhere((element) => element.name == listName);
    list.name = newName;
    saveGuardLists();
    notifyListeners();
  }
}
