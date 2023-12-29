import 'package:maazin_app/models/assigned_team_member.dart';
import 'package:maazin_app/models/team_member.dart';
import 'dart:math';

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
      Duration(minutes: (totalDuration.inMinutes / numGroups / roundToInMinutes).ceil() * roundToInMinutes);

    // Initialize the list of groups
    List<List<AssignedTeamMember>> groups = [];

    // Initialize the current time for assigning guard time
    DateTime currentTime = startTime;

    Duration tempDuration = Duration.zero;
    while( tempDuration.inMinutes < totalDuration.inMinutes )
    {
      // Group the shuffled members into equal-sized groups
      for (int i = 0; i < numGroups; i++) {
        int start = i * groupSize;
        int end = min((i + 1) * groupSize, enabledMembers.length);
        List<AssignedTeamMember> group = [];

        late DateTime memberEndTime;

        // Assign guard time to the group
        for (int j = 0; j < end - start; j++) {
          DateTime memberStartTime = currentTime;
          memberEndTime = memberStartTime.add(groupDuration);
          group.add(AssignedTeamMember(enabledMembers[start + j].name, enabledMembers[start +j].isEnabled, memberStartTime, memberEndTime));  
        }

        currentTime = memberEndTime;

        groups.add(group);

        tempDuration += groupDuration;

        if (tempDuration  >=  totalDuration)
        {
          break;
        }
      }

    }

    return groups;
  }
}