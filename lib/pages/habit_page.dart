import 'package:daylist/components/my_habit_tile.dart';
import 'package:daylist/components/my_heat_map.dart';
import 'package:daylist/components/my_textfield.dart';
import 'package:daylist/database/habit_database.dart';
import 'package:daylist/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/habit_utils.dart';
import '../utils/life_cycle.dart';
import 'package:avatar_glow/avatar_glow.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  // start date
  DateTime? startDate;

  @override
  void initState() {
    // read exisiting habits on startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    // print all habit data
    Provider.of<HabitDatabase>(context, listen: false).printAllHabits();

    // begin period calls
    // (this is for a specific case where the user returns to the app past midnight,
    // and so the app needs to refresh when they return)
    periodCalls();

    super.initState();
  }

  // check when the app resumes
  void periodCalls() {
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async => setState(
          () {
            // do something
            print('app resumed');
            // read exisiting habits on startup
            Provider.of<HabitDatabase>(context, listen: false).readHabits();
          },
        ),
      ),
    );
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  // create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: MyTextField(
          controller: textController,
          hintText: "Create a new habit:",
        ),
        actions: [
          // create button
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;

              // save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: Text('Create', 
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).colorScheme.inversePrimary
                )
              )
            )
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
              // clear controller
              textController.clear();
            },
            child: Text('Cancel', 
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).colorScheme.inversePrimary
                )
              )
            )
          ),
        ],
      ),
    );
  }

  // check on and off habit
  void checkOffHabit(bool? newValue, Habit habit) {
    {
      // Update the habit's completion status
      if (newValue != null) {
        context.read<HabitDatabase>().updateHabitCompletion(habit.id, newValue);
      }
    }
  }

  // edit habit box
  void editHabit(Habit habit) {
    // Set the text controller's text to the habit's current name
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("Edit", 
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary
            )
          )
        ),
        content: MyTextField(
          hintText: "Edit",
          controller: textController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;

              // save to db
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: Text('Save', 
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).colorScheme.inversePrimary
                )
              )
            ),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
              // clear controller
              textController.clear();
            },
            child: Text('Cancel', 
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).colorScheme.inversePrimary
                )
              )
            ),
          ),
        ],
      ),
    );
  }

  // delete habit box
  void deleteHabit(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: 
          Text("Are you sure you want to delete?",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color:Theme.of(context).colorScheme.inversePrimary
              ),
            ),
          ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              // save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // pop box
              Navigator.pop(context);
            },
            child: Text('Delete', 
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).colorScheme.inversePrimary
                )
              )
            ),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: Text('Cancel', 
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).colorScheme.inversePrimary
                )
              )
            ),
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/page1.1.png'), // Replace with your image path
          fit: BoxFit.cover, // Adjust to fit the image properly
        ),
      ),
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: null,
            flexibleSpace: Center( // Center the text
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0), // Optional: Adjust top padding
                child: Text(
                  'Study Tracker',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Move the heat map outside of the ListView
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0), // Adjust padding as needed
            child: _buildHeatMap(),
          ),
          // Expanded ListView for the habit list
          Expanded(
            child: ListView(
              children: [
                // H A B I T S
                _buildHabitList(),
              ],
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.963, // Adjust this value to move the button down
          left: MediaQuery.of(context).size.width * 0.5 - 35, // Centers the button (56/2 = 28)
          child: AvatarGlow(
            glowColor: Theme.of(context).colorScheme.tertiary,
            glowRadiusFactor: 1.0,
            child: SizedBox(
              width: 100.0, // Adjust the width to change the button size
              height: 30.0, // Adjust the height to change the button size
              child: FloatingActionButton(
                onPressed: createNewHabit,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}



  // build heat map
  Widget _buildHeatMap() {
    // habit database
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Once the data is available, build the HeatMap
          return MyHeatMap(
            dataset: createHeatMapDataset(currentHabits),
            startDate: snapshot.data!,
          );
        } else {
          // Handle the case where no data is returned
          return Container();
        }
      },
    );
  }

  // build habit list
  Widget _buildHabitList() {
    // habit database
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return habit tile UI
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (bool? newValue) => checkOffHabit(newValue, habit),
          editHabit: (context) => editHabit(habit),
          deleteHabit: (context) => deleteHabit(habit),
        );
      },
    );
  }
}