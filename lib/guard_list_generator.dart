import 'package:maazin_app/models/assigned_team_member.dart';
import 'package:maazin_app/models/team_member.dart';
import 'dart:math';

class GuardListGenerator {
  List<List<AssignedTeamMember>> generateGuardGroups(List<TeamMember> teamMembers, int groupSize, DateTime startTime, DateTime endTime) {
    // Shuffle the teamMembers list randomly
    teamMembers.shuffle();

    // Calculate the number of groups needed
    int numGroups = (teamMembers.length / groupSize).ceil();

    // Calculate the total duration for guard time
    Duration totalDuration = endTime.difference(startTime);

    // Calculate the duration for each group
    Duration groupDuration = Duration(milliseconds: totalDuration.inMilliseconds ~/ numGroups);

    // Initialize the list of groups
    List<List<AssignedTeamMember>> groups = [];

    // Initialize the current time for assigning guard time
    DateTime currentTime = startTime;

    // Group the shuffled members into equal-sized groups
    for (int i = 0; i < numGroups; i++) {
      int start = i * groupSize;
      int end = min((i + 1) * groupSize, teamMembers.length);
      List<AssignedTeamMember> group = [];

      late DateTime memberEndTime;

      // Assign guard time to the group
      for (int j = 0; j < end - start; j++) {
        DateTime memberStartTime = currentTime;
        memberEndTime = memberStartTime.add(groupDuration);
        group.add(AssignedTeamMember(teamMembers[start + j].name, memberStartTime, memberEndTime));  
      }

      currentTime = memberEndTime;

      groups.add(group);
    }

    return groups;
  }
}