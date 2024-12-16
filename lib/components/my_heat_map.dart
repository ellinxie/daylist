import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> dataset;
  final DateTime startDate;

  const MyHeatMap({
    super.key,
    required this.dataset,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: HeatMap(
        startDate: startDate,
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: dataset,
        colorMode: ColorMode.color,
        defaultColor: Theme.of(context).colorScheme.tertiary,
        textColor: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
        ).color, // Get the color defined in the font style.
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(100, 50, 171, 56),
          2: Color.fromARGB(130, 50, 171, 56),
          3: Color.fromARGB(160, 50, 171, 56),
          4: Color.fromARGB(190, 50, 171, 56),
          5: Color.fromARGB(220, 50, 171, 56),
          6: Color.fromARGB(250, 50, 171, 56),
        },
      ),
    );
  }
}
