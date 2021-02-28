import 'package:intl/intl.dart';

class UpdatedTime {

  static const NOW = "now";
  static const N_MINUTES = "min ago";
  static const N_HOURS = "h ago";
  static const N_DAYS = "d ago";
  static const N_WEEKS = "w ago";

  static String name(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.compareTo(Duration(minutes: 1)) < 0) return NOW;
    if (diff.compareTo(Duration(hours: 1)) < 0) return minutes(diff.inMinutes);
    if (diff.compareTo(Duration(days: 1)) < 0) return hours(diff.inHours);
    if (diff.compareTo(Duration(days: 7)) < 0) return days(diff.inDays);
    if (diff.compareTo(Duration(days: 7*5)) < 0) return weeks((diff.inDays/7).toInt());
    return plain(dt);
  }

  static String minutes(int n) => "$n$N_MINUTES";
  static String hours(int n) => "$n$N_HOURS";
  static String days(int n) => "$n$N_DAYS";
  static String weeks(int n) => "$n$N_WEEKS";
  static String plain(DateTime dt) => "${dt.day} ${DateFormat.MMM().format(dt)}";

}