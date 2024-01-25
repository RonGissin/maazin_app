import 'date_formatter.dart';
import '../models/assigned_team_member_model.dart';

class WhatsappGuardListFormatter {
  static String ListToString(List<List<AssignedTeamMemberModel>> guardGroups) {
    StringBuffer formattedList = StringBuffer();
    formattedList.writeln('*Guard List*'); // WhatsApp markdown for bold text

    for (int i = 0; i < guardGroups.length; i++) {
      formattedList.write('- ');
      for (int j = 0; j < guardGroups[i].length; j++) {
        formattedList.write('${guardGroups[i][j].name}');
        if (j < guardGroups[i].length - 1) {
          formattedList.write(', ');
        }
      }
      formattedList.write(' - ${DateFormatter.formatTime(guardGroups[i][0].startTime)} to ${DateFormatter.formatTime(guardGroups[i][0].endTime)}\n');
    }

    return formattedList.toString();
  }
}