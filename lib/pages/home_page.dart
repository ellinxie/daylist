import 'package:daylist/components/study_input.dart';
import 'package:daylist/utils/home_clock.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/page1.2.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Column(
            children: [
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: null,
                flexibleSpace: const Center( // Center the text
                  child: Padding(
                    padding: EdgeInsets.only(top: 500.0), // Optional: Adjust top padding
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Digital clock widget
                      DigitalClockWidget(),
                      SizedBox(height: 40),
                      // Study input widget
                      StudyInput(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

