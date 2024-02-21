import 'package:flutter/material.dart';
import 'note_screen.dart';
import 'note.dart'; // Import the Note class

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<note> notes = []; // List to store notes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      backgroundColor: Colors.lightGreen, // Set the background color
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text(notes[index].content),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to note creation page and wait for a result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNoteScreen()),
          );

          // Handle the result (created note)
          if (result != null && result is Note) {
            setState(() {
              notes.add(result); // Add the created note to the list
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
