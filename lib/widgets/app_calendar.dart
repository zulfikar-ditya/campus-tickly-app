import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/formatters.dart';

/// Inline month calendar used in the Filters sheet. Supports a single
/// [selectedDate] (filled circle) and an optional highlighted [rangeStart]..
/// [rangeEnd] band. Month navigation is delegated via [onMonthChanged].
class AppCalendar extends StatelessWidget {
  const AppCalendar({
    super.key,
    required this.month,
    this.selectedDate,
    this.rangeStart,
    this.rangeEnd,
    this.onDaySelected,
    this.onMonthChanged,
  });

  /// Any date within the month to display.
  final DateTime month;
  final DateTime? selectedDate;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final ValueChanged<DateTime>? onDaySelected;
  final ValueChanged<DateTime>? onMonthChanged;

  static const List<String> _weekdayHeaders = <String>[
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  bool _sameDay(DateTime? a, DateTime? b) =>
      a != null &&
      b != null &&
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;

  bool _inRange(DateTime day) {
    if (rangeStart == null || rangeEnd == null) return false;
    final DateTime d = DateTime(day.year, day.month, day.day);
    return !d.isBefore(rangeStart!) && !d.isAfter(rangeEnd!);
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final DateTime first = DateTime(month.year, month.month, 1);
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Sunday-first column offset (DateTime.weekday: Mon=1..Sun=7).
    final int leadingBlanks = first.weekday % 7;

    final List<DateTime?> cells = <DateTime?>[
      ...List<DateTime?>.filled(leadingBlanks, null),
      for (int d = 1; d <= daysInMonth; d++)
        DateTime(month.year, month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(monthYearLabel(month), style: context.text.titleMedium),
            const Spacer(),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.chevron_left_rounded),
              color: c.textSecondary,
              onPressed: onMonthChanged == null
                  ? null
                  : () =>
                        onMonthChanged!(DateTime(month.year, month.month - 1)),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.chevron_right_rounded),
              color: c.textSecondary,
              onPressed: onMonthChanged == null
                  ? null
                  : () =>
                        onMonthChanged!(DateTime(month.year, month.month + 1)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            for (final String h in _weekdayHeaders)
              Expanded(
                child: Center(
                  child: Text(
                    h,
                    style: context.text.bodySmall?.copyWith(color: c.textMuted),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (int row = 0; row < cells.length ~/ 7; row++)
          Row(
            children: <Widget>[
              for (int col = 0; col < 7; col++)
                _DayCell(
                  day: cells[row * 7 + col],
                  selected:
                      _sameDay(cells[row * 7 + col], selectedDate) ||
                      _sameDay(cells[row * 7 + col], rangeStart) ||
                      _sameDay(cells[row * 7 + col], rangeEnd),
                  inRange:
                      cells[row * 7 + col] != null &&
                      _inRange(cells[row * 7 + col]!),
                  onTap: onDaySelected,
                ),
            ],
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.inRange,
    this.onTap,
  });

  final DateTime? day;
  final bool selected;
  final bool inRange;
  final ValueChanged<DateTime>? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    if (day == null) return const Expanded(child: SizedBox(height: 44));

    final Color textColor = selected
        ? c.onPrimary
        : inRange
        ? c.primary
        : c.textPrimary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap == null ? null : () => onTap!(day!),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 44,
          color: inRange && !selected
              ? c.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? c.primary : Colors.transparent,
            ),
            child: Text(
              '${day!.day}',
              style: context.text.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
