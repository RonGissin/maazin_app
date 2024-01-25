import 'assigned_team_member_model.dart';

class GuardListModel {
  String name;
  List<List<AssignedTeamMemberModel>> guardGroups;

  GuardListModel({required this.name, required this.guardGroups});
}
