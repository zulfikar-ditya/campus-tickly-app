import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'date_cell.dart';

/// Horizontal scrollable strip of [DateCell]s for a week. The currently
/// [selectedDate] is highlighted; tapping a day calls [onSelect].
class WeekDateStrip extends StatelessWidget {
  const WeekDateStrip({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onSelect,
  });

  final List<DateTime> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  /// Seven consecutive days starting from [start] (defaults to today).
  static List<DateTime> week({DateTime? start}) {
    final DateTime base = start ?? DateTime.now();
    final DateTime day = DateTime(base.year, base.month, base.day);
    return List<DateTime>.generate(7, (int i) => day.add(Duration(days: i)));
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int i) {
          final DateTime day = days[i];
          return DateCell(
            date: day,
            selected: _sameDay(day, selectedDate),
            onTap: () => onSelect(day),
          );
        },
      ),
    );
  }
}
