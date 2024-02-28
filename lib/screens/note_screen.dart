import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController bulletPointController =
      TextEditingController(); // Add this line

  double fontSize = 16.0;
  List<String> lines = [];
  List<bool> checklistItems = [];
  List<TextEditingController> checklistControllers = [];

  @override
/*
  void initState() {
    super.initState();
    loadPreviousNote();
  }
*/

  /*void loadPreviousNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      titleController.text = prefs.getString('title') ?? '';
      contentController.text = prefs.getString('content') ?? '';
    });
  }

  void saveNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('title', titleController.text);
    prefs.setString('content', contentController.text);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REMINDERS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              /*// Handle save note functionality
              saveNote();
              // Clear text fields after saving the note
              titleController.clear();
              contentController.clear();
              bulletPointController.clear(); // Clear bullet point controller
              // Also, clear the checklist and lines if needed*/
              setState(() {
                checklistItems.clear();
                checklistControllers.clear();
                lines.clear();
              });
              // Save the note or navigate back to the home screen
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: checklistItems.length,
                  itemBuilder: (context, index) {
                    return Row(children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: TextField(
                            controller: checklistControllers[index],
                            decoration: InputDecoration(
                                hintText: 'Checklist item ${index + 1}'),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: checklistItems[index],
                          onChanged: (value) {
                            setState(() {
                              checklistItems[index] = value!;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            checklistItems.removeAt(index);
                            checklistControllers.removeAt(index);
                          });
                        },
                        color: Color(0xff212435),
                        iconSize: 24,
                      )
                    ]);
                  },
                  // ),
                ),
              ],
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: addChecklistItem,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add Bullet Points Functionality

  // Add Checklist Item Functionality
  void addChecklistItem() {
    setState(() {
      checklistItems.insert(0, false); // Prepend the new checklist item
      checklistControllers.insert(
          0, TextEditingController()); // Prepend the new controller
    });
  }
}
