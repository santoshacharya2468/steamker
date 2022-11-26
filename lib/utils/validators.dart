// @dart=2.9

import 'package:url_launcher/url_launcher.dart';

final String support = 'https://api.whatsapp.com/send?phone=';

void launchSupport() async => await canLaunch(support)
    ? await launch(support)
    : throw 'Could not launch $support';

String numberValidator(String value) {
  return value.length < 1
      ? "* Required Field"
      : num.tryParse(value) == null
          ? '"$value" is not a valid number'
          : null;
}

String validateEmail(String value) {
  Pattern pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = new RegExp(pattern);
  if (value.length < 1) return "* Required Field";
  if (!regex.hasMatch(value) || value == null)
    return 'Invalid E-mail Address';
  else
    return null;
}

String passValidator(String value, ps1, ps2) {
  return value.length < 1
      ? "* Required Field"
      : ps1 == ps2
          ? null
          : "Password Doesn't Match";
}

String otherValidator(String value) {
  return value.length < 1 ? "* Required Field" : null;
}

List<String> getDaysInBeteween(DateTime startDate, DateTime endDate) {
  List<String> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(DateTime(startDate.year, startDate.month, startDate.day + i)
        .toString()
        .split(" ")[0]);
  }
  return days;
}

List<String> getDaysAllFridays(DateTime startDate, DateTime endDate) {
  List<String> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    if (DateTime(startDate.year, startDate.month, startDate.day + i).weekday ==
        DateTime.friday)
      days.add(DateTime(startDate.year, startDate.month, startDate.day + i)
          .toString()
          .split(" ")[0]);
  }
  return days;
}

List<String> getDaysAllSaturdays(DateTime startDate, DateTime endDate) {
  List<String> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    if (DateTime(startDate.year, startDate.month, startDate.day + i).weekday ==
        DateTime.saturday)
      days.add(DateTime(startDate.year, startDate.month, startDate.day + i)
          .toString()
          .split(" ")[0]);
  }
  return days;
}

List<String> getAllBlankDays(List<Map<DateTime, DateTime>> dates) {
  List<String> days = []; //all blank days
  List<String> allDays = []; // all package dates
  for (int i = 0; i < dates.length; i++) {
    List<String> b =
        getDaysInBeteween(dates[i].keys.first, dates[i].values.first);
    allDays.addAll(b);
  }
  for (int i = 0;
      i <= dates.last.values.last.difference(dates.first.keys.first).inDays;
      i++) {
    if (!allDays.contains(DateTime(dates.first.keys.first.year,
            dates.first.keys.first.month, dates.first.keys.first.day + i)
        .toString()
        .split(" ")[0]))
      days.add(DateTime(dates.first.keys.first.year,
              dates.first.keys.first.month, dates.first.keys.first.day + i)
          .toString()
          .split(" ")[0]);
  }
  List<String> before = getDaysInBeteween(
      dates.first.keys.first.subtract(Duration(days: 32)),
      dates.first.keys.first.subtract(Duration(days: 1)));
  days.addAll(before);
  List<String> after = getDaysInBeteween(
      dates.last.values.last.add(Duration(days: 1)),
      dates.last.values.last.add(Duration(days: 32)));
  days.addAll(after);
  return days;
}
