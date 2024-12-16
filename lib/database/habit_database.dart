import 'package:flutter/material.dart';
import 'package:daylist/models/app_settings.dart';
import 'package:daylist/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

// set up

  // init database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // save first date for heat map
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // get first app launch date
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

// operations

  // list
  final List<Habit> currentHabits = [];

  // create habit
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read from db
    readHabits();
  }

  // read saved
  Future<void> readHabits() async {
    // fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();
  }

  // update habit completion status
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();

          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        }

        else if (!isCompleted) {

          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  // edit habit
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  // delete habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // re-read from db
    readHabits();
  }

  Future<void> printAllHabits() async {
    final allHabits = await isar.habits.where().findAll();
    for (var habit in allHabits) {
      print('Habit: ${habit.name}');
      print('Completion Dates: ${habit.completedDays}');
    }
  }
}
