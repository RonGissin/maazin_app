import 'team_member_model.dart';

class AssignedTeamMemberModel extends TeamMemberModel {
  DateTime startTime;
  DateTime endTime;

  AssignedTeamMemberModel(String name, bool isEnabled, this.startTime, this.endTime) : super(name: name, isEnabled: isEnabled);
}