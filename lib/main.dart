import 'package:daylist/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daylist/pages/pomodoro_page.dart';
import 'package:daylist/pages/habit_page.dart';
import 'package:daylist/pages/home_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'database/habit_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final controller = PageController(initialPage: 1); // Start at HomePage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: const [
              HabitPage(), // Left page
              HomePage(),  // Middle page
              PomodoroTimerPage(), // Right page
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.92,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  dotHeight: 5,
                  dotWidth: 15,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
