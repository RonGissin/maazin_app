import 'date_formatter.dart';
import '../models/assigned_team_member.dart';

class WhatsappGuardListFormatter {
  static String ListToString(List<List<AssignedTeamMember>> guardGroups) {
    StringBuffer formattedList = StringBuffer();
    int currentDay= guardGroups[0][0].startTime.day;
    int cuttentMonth= guardGroups[0][0].startTime.month;
    formattedList.writeln('*Guard List*'); // WhatsApp markdown for bold text
    formattedList.writeln(DateFormatter.formatDate(guardGroups[0][0].startTime)); // WhatsApp markdown for bold text

    for (int i = 0; i < guardGroups.length; i++) {

       int tempDay = guardGroups[i][0].startTime.day;
       int tempMonth = guardGroups[i][0].startTime.month;

      if (tempDay > currentDay || tempMonth > cuttentMonth)
      {
        currentDay = tempDay;
        cuttentMonth=tempMonth;
        formattedList.writeln('${DateFormatter.formatDate(guardGroups[i][0].startTime)}'); // WhatsApp markdown for bold text
      }

      formattedList.write('- ');
      for (int j = 0; j < guardGroups[i].length; j++) {
        formattedList.write('${guardGroups[i][j].name}');
        if (j < guardGroups[i].length - 1) {
          formattedList.write(', ');
        }
      }
     
      formattedList.write(' : ${DateFormatter.formatTime(guardGroups[i][0].startTime)} - ${DateFormatter.formatTime(guardGroups[i][0].endTime)}\n');
    }

    return formattedList.toString();
  }
}