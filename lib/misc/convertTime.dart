import 'package:intl/intl.dart';
convertTimeTo12Hour(time24) {
  return DateFormat('h:mm a dd/MM/yyyy').format(time24);
}