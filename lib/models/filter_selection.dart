import 'task_category.dart';

/// Date-range options in the Filters sheet.
enum DateRangeFilter {
  all('All'),
  today('Today'),
  yesterday('Yesterday'),
  last7Days('Last 7 days'),
  custom('Custom');

  const DateRangeFilter(this.label);

  final String label;
}

/// The set of filters applied to the task list. A null [category] means "All
/// types"; [customDate] is only meaningful when [dateRange] is `custom`.
class FilterSelection {
  const FilterSelection({
    this.dateRange = DateRangeFilter.all,
    this.customDate,
    this.category,
  });

  final DateRangeFilter dateRange;
  final DateTime? customDate;
  final TaskCategory? category;

  bool get isDefault =>
      dateRange == DateRangeFilter.all && customDate == null && category == null;

  FilterSelection copyWith({
    DateRangeFilter? dateRange,
    DateTime? customDate,
    bool clearCustomDate = false,
    TaskCategory? category,
    bool clearCategory = false,
  }) {
    return FilterSelection(
      dateRange: dateRange ?? this.dateRange,
      customDate: clearCustomDate ? null : (customDate ?? this.customDate),
      category: clearCategory ? null : (category ?? this.category),
    );
  }
}
