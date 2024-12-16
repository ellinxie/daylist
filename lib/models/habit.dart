import 'package:isar/isar.dart';

// run cmd: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  // habit id
  Id id = Isar.autoIncrement;

  // habit name
  late String name;

  // completed day
  List<DateTime> completedDays = [
    // DateTime(2023,12,31),
    // DateTime(2024,1,1),
    // DateTime(2024,1,2),
    // DateTime(2024,1,3)
  ];
}
