import 'package:flutter/material.dart';
import 'note_screen.dart';
import 'note.dart'; // Import the Note class

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreemState createState() => _HomeScreemState();
}

class _HomeScreemState extends State <HomeScreen> {

  void settingsManager() {

}

void modeHandler() {

}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Reminders App'
        ),
        actions: [
          IconButton(
              tooltip: 'Settings',
              onPressed: (){
                  settingsManager();
              },
              icon: const Icon(Icons.settings)
          )
        ],
      ),
      backgroundColor: Colors.lightGreen, // Set the background color
      body: GridView.count(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          padding: EdgeInsets.all(16.0),
          children: [
            InkWell(
              onTap: (){
                modeHandler();
              },
              child: _buildModeCard("Home", Icons.home, Colors.blue),
            ),
            InkWell(
              onTap: (){
                modeHandler();
              },
              child: _buildModeCard("Work", Icons.work, Colors.orange),
            ),
            InkWell(
              onTap: (){
                modeHandler();
              },
              child: _buildModeCard("Holiday", Icons.beach_access, Colors.green),
            ),
            InkWell(
              onTap: (){
                modeHandler();
              },
              child: _buildModeCard("Car", Icons.directions_car, Colors.red),
            ),



          ],
        ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new reminder
          print("Adding a new reminder");
        },
        child: Icon(Icons.add),
      ),
    );
  }


  Widget _buildModeCard(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle mode selection here
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
                style: TextStyle(
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
