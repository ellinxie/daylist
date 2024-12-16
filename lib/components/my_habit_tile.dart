import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const StretchMotion(),
          children: [
            // edit option
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),

            // delete option
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted); // Toggle the completion status
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.withOpacity(0.5)
                  : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8)
            ),
            child: ListTile(
              title: Text(
                text,
                style: GoogleFonts.montserrat
                (textStyle: TextStyle (
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? Colors.white
                      : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              leading: Checkbox(
                activeColor: Colors.green,
                value: isCompleted,
                onChanged: onChanged,
                side: BorderSide(
                  color: isCompleted
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.inversePrimary,
                  width: 2.0,
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
