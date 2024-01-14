import 'team_member.dart';

class AssignedTeamMember extends TeamMember {
  DateTime startTime;
  DateTime endTime;

  AssignedTeamMember(String name, bool isEnabled, this.startTime, this.endTime) : super(name: name, isEnabled: isEnabled);
}