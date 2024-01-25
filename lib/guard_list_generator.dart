import '../models/assigned_team_member.dart';
import '../models/team_member.dart';

const int roundToInMinutes = 5;

class GuardListGenerator {
  List<List<AssignedTeamMember>> generateGuardGroups(
    List<TeamMember> teamMembers, 
    int groupSize, 
    DateTime startTime,
    DateTime endTime, 
    int? guardTime) {

    // Shuffle the teamMembers list randomly
    var enabledMembers = teamMembers.where((m) => m.isEnabled).toList();
    enabledMembers.shuffle();

    // Calculate the number of groups needed
    int numGroups = (enabledMembers.length / groupSize).ceil();

    // Calculate the total duration for guard time
    Duration totalDuration = endTime.difference(startTime) ;

    // Calculate the duration for each group (5 minutes is the smallest time batch)
    Duration groupDuration = guardTime != null ?
      Duration(minutes:guardTime):
      Duration(minutes: (totalDuration.inMinutes / numGroups / roundToInMinutes).floor() * roundToInMinutes);

    // Initialize the list of groups
    List<List<AssignedTeamMember>> groups = [];

    // Initialize the current time for assigning guard time
    DateTime currentTime = startTime;

    Duration tempDuration = Duration.zero;
    int teamMemberPointer = 0;

    while(tempDuration.inMinutes < totalDuration.inMinutes)
    {
      List<AssignedTeamMember> group = [];
      late DateTime memberEndTime;

      for (int i = 0; i < groupSize; i++) {
        // Assign guard time to the group
        DateTime memberStartTime = currentTime;
        memberEndTime = memberStartTime.add(groupDuration);

        var teamMember = enabledMembers[teamMemberPointer];

        group.add(AssignedTeamMember(teamMember.name, teamMember.isEnabled, memberStartTime, memberEndTime)); 

        teamMemberPointer = (teamMemberPointer + 1) % enabledMembers.length;
      }

      currentTime = memberEndTime;
      groups.add(group);
      tempDuration += groupDuration;

      if (tempDuration >= totalDuration)
      {
        break;
      }
    }

    
    // let the last group guard a bit more if needed..
    if (groups.isNotEmpty && groups.last[0].endTime.isBefore(endTime)) {
      groups.last.forEach((guard) {
        guard.endTime = endTime;
      });
    }

    return groups;
  }
}