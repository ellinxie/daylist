import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/habit_database.dart';

void _startMidnightResetTimer(BuildContext context) {
  Timer.periodic(Duration(minutes: 1), (timer) {
    final now = DateTime.now();
    // Check if it's just past midnight (00:01 allows a 1-minute buffer)
    if (now.hour == 0 && now.minute == 1) {
      Provider.of<HabitDatabase>(context, listen: false).readHabits();
    }
  });
}
