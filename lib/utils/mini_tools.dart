import 'package:url_launcher/url_launcher_string.dart';

class MiniTool {
  static DateTime justDate(DateTime day) =>
      DateTime(day.year, day.month, day.day);

  static bool isSameDay(DateTime day_1, DateTime day_2) =>
      day_1.year == day_2.year &&
      day_1.month == day_2.month &&
      day_1.day == day_2.day;

  static void launchUrl(String url) async {
    if (await canLaunchUrlString(url))
      await launchUrlString(url, mode: LaunchMode.externalApplication);
  }
}
