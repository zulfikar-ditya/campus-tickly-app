/// Lightweight date/time formatting helpers (no `intl` dependency yet).
const List<String> _monthsShort = <String>[
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const List<String> _weekdaysShort = <String>[
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];

const List<String> _monthsFull = <String>[
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// "Jun 9, 2026"
String formatDate(DateTime date) =>
    '${_monthsShort[date.month - 1]} ${date.day}, ${date.year}';

/// "June 2026" — calendar header.
String monthYearLabel(DateTime date) =>
    '${_monthsFull[date.month - 1]} ${date.year}';

/// Short weekday label, e.g. "Fri". [DateTime.weekday] is 1 (Mon)..7 (Sun).
String weekdayLabel(DateTime date) => _weekdaysShort[date.weekday - 1];

/// 12-hour clock, e.g. "2:00 PM" / "9:05 AM".
String formatClock(DateTime time) {
  final int hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final String minute = time.minute.toString().padLeft(2, '0');
  final String period = time.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}
