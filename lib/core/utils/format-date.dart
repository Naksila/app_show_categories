import 'package:intl/intl.dart';

String formatDateStringDDMMYYtoDate(String date) {
  if (date.isEmpty) {
    return '';
  }

  DateTime parseDate = DateFormat('yyyy-MM-dd').parse(date);

  DateFormat outputFormatDD = DateFormat('dd');
  DateFormat outputFormatMM = DateFormat('MMM');
  DateFormat outputFormatYYYY = DateFormat('yyyy');

  String dd = outputFormatDD.format(parseDate);
  String mm = outputFormatMM.format(parseDate);
  int yy = int.parse(outputFormatYYYY.format(parseDate));
  // if (localeDate == 'th') {
  //   yy = yy + 543;
  // }

  return '$dd $mm $yy';
}

String stringDateDDMMYYYYtoDate(String date) {
  String dateResult = "";
  try {
    DateTime parseDate = DateFormat('dd/MM/yyyy').parse(date);
    dateResult = parseDate.toString();
  } catch (e) {}
  return dateResult;
}
