// given a habits list of completion days,
// is the habit completed today
import '../models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

Map<DateTime, int> createHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // Normalize the date to avoid time part
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // If the date already exists in the dataset, increment its count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        // Else, initialize it with a count of 1
        dataset[normalizedDate] = 1;
      }
    }
  }

  return dataset;
}
