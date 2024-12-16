import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class PomodoroTimerPage extends StatefulWidget {
  const PomodoroTimerPage({super.key});

  @override
  _PomodoroTimerPageState createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  static const int workDuration = 25 * 60; // 25 minutes
  static const int breakDuration = 5 * 60; // 5 minutes

  int currentDuration = workDuration;
  bool isRunning = false;
  bool isWorkSession = true;
  int sessionCount = 0; // Tracks completed sessions

  Timer? timer;

  // List to store completed study sessions
  final List<Map<String, dynamic>> studySessions = [];

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentDuration > 0) {
          currentDuration--;
        } else {
          timer.cancel();
          if (isWorkSession && sessionCount < 4) {
            sessionCount++; // Increment session count after work session
            addStudySession();
          }
          switchMode();
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      currentDuration = isWorkSession ? workDuration : breakDuration;
      sessionCount = 0; // Reset session count
    });
  }

  void switchMode() {
    setState(() {
      isWorkSession = !isWorkSession;
      currentDuration = isWorkSession ? workDuration : breakDuration;
    });
    startTimer(); // Automatically start the next timer
  }

  void addStudySession() {
    final studySession = {
      'sessionType': isWorkSession ? 'Work Session' : 'Break Time',
      'duration': isWorkSession ? workDuration : breakDuration,
      'date': DateTime.now(), // Ensure this is never null
    };

    setState(() {
      studySessions.add(studySession);
    });
  }

  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatDuration(int duration) {
    final int minutes = duration ~/ 60;
    return '$minutes min';
  }

  @override
  @override
Widget build(BuildContext context) {
  return Stack(
    children: [
      // Background image that spans the entire screen
      Positioned.fill(
        child: Image.asset(
          'lib/assets/page1.3.png', // Replace with your image path
          fit: BoxFit.cover, // Adjust the image fitting as needed
        ),
      ),
      // Scaffold with transparent AppBar
      Scaffold(
        backgroundColor: Colors.transparent, // Ensure transparency
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: null,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Text(
                  'Pomodoro Timer',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AvatarGlow(
                      glowColor: Theme.of(context).colorScheme.tertiary,
                      glowRadiusFactor: .2,
                      duration: const Duration(seconds: 4),
                      repeat: isRunning,
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: 1 - currentDuration / (isWorkSession ? workDuration : breakDuration),
                          strokeWidth: 15,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isWorkSession ? 'Study' : 'Rest',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatTime(currentDuration),
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isRunning ? pauseTimer : startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        isRunning ? 'Pause' : 'Start',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: resetTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        'Reset',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Text(
                  'Sessions Completed:',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < sessionCount
                              ? Colors.green
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
