class DateFormatter {
  static String formatTime(DateTime dateTime) {
    final String formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }
    static String formatTimeWithSeconds(DateTime dateTime) {
    final String formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    return formattedTime;
  }
  static String formatDate(DateTime dateTime) {
    final String formattedTime =
        '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';
    return formattedTime;
  }
  
  }