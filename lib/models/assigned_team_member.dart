import 'team_member.dart';

class AssignedTeamMember extends TeamMember {
  final DateTime startTime;
  final DateTime endTime;

  AssignedTeamMember(String name, this.startTime, this.endTime) : super(name: name);
}