// import 'package:intl/intl.dart' as intl;
// import 'package:timeago/timeago.dart' as timeago;
import 'package:date_format/date_format.dart';

String convertToAgo(DateTime input) {
  Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 1) {
    return '${diff.inDays} day(s) ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour(s) ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minute(s) ago';
  } else if (diff.inSeconds >= 1) {
    return '${diff.inSeconds} second(s) ago';
  } else {
    return 'just now';
  }
}

String dateAtTime(DateTime dateTime) {
  return formatDate(
      dateTime, [d, ' ', M, ' ', yyyy, " at ", h, ":", nn, " ", am]);
}


// String toReadableTime(DateTime datetime) {
//   if (datetime == null) {
//     return '';
//   }

//   final intl.DateFormat formatter = intl.DateFormat('E, LLL d, yyyy h:m a');

//   final DateTime currentTime = DateTime.now();
//   final Duration differnceTime = currentTime.difference(datetime);

//   String formatted = timeago.format(datetime);

//   if (differnceTime.inDays < 1) {
//     formatted = timeago.format(datetime);
//   } else if (differnceTime.inDays > 1) {
//     formatted = formatter.format(datetime);
//   }

//   return formatted;
// }
