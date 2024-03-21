import 'package:flutter/material.dart';
import 'RemindersPage.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:firebase_analytics/firebase_analytics.dart'
import 'Backend/modes.dart';
// import 'note.dart'; // Import the Note class

class ModePage extends StatefulWidget {
  //Add connection property

  @override
  _ModePageState createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  // late List<Mode> _modes = [];

  void modeHandler(int mode_id) {
    print("Selected mode: $mode_id");
  }

  @override
  void initState() {
    super.initState();
  }

  void _navigateToReminderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateNoteScreen()), //mode_id: mode_id),
    );
  }

  void _getSettings() {
    // db.getConnection().then((conn) {
    //   String sql = 'select '
    // });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reminders App'),
          actions: [
            IconButton(
                tooltip: 'Settings',
                onPressed: () {},
                icon: const Icon(Icons.settings))
          ],
        ),
        backgroundColor: Colors.lightGreen, // Set the background color
        body: GridView.count(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          padding: EdgeInsets.all(16.0),
          children: [
            // _modes.map((mode) {
            InkWell(
              onTap: () {
                _navigateToReminderPage();
                // modeHandler(mode.id);
              },
              child: _buildModeCard(
                "Home",
                Icons.home,
                Colors.blue,
              ),
            ),
            InkWell(
              onTap: () async {
                _navigateToReminderPage();
              },
              child: _buildModeCard("Work", Icons.work, Colors.orange),
            ),
            InkWell(
              onTap: () {
                _navigateToReminderPage();
              },
              child:
                  _buildModeCard("Holiday", Icons.beach_access, Colors.green),
            ),
            InkWell(
              child: _buildModeCard("Car", Icons.directions_car, Colors.red),
              onTap: () {
                _navigateToReminderPage();
              },
            ),
            // }).toList()),
          ],

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     // Handle adding a new reminder
          //     print("Adding a new reminder");
          //     final result = await Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => CreateNoteScreen()));
          //   },
          //   child: Icon(Icons.add),
          // ),
        ));
  }

  Widget _buildModeCard(
    String label,
    IconData icon,
    Color color,
    //  Mode mode
  ) {
    return GestureDetector(
      onTap: () {
        // Handle mode selection here
        _navigateToReminderPage();
        // modeHandler(mode.id);
        print("Selected mode: $label");
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: Colors.white,
              ),
              SizedBox(height: 8.0),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
