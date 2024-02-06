import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController bulletPointController = TextEditingController(); // Add this line

  double fontSize = 16.0;
  List<String> lines = [];
  List<bool> checklistItems = [];
  List<TextEditingController> checklistControllers = [];
  bool isDrawingMode = false;

  @override
  void initState() {
    super.initState();
    loadPreviousNote();
  }

  void loadPreviousNote() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Handle save note functionality
              saveNote();
              // Clear text fields after saving the note
              titleController.clear();
              contentController.clear();
              bulletPointController.clear(); // Clear bullet point controller
              // Also, clear the checklist and lines if needed
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: contentController,
              maxLines: null,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'AmaticSC',
                fontWeight: FontWeight.normal,
              ),
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 16),
            // TextField for bullet points
            TextField(
              controller: bulletPointController,
              decoration: const InputDecoration(labelText: 'Bullet Point'),
            ),
            const SizedBox(height: 16),
            // Button to add bullet points
            ElevatedButton(
              onPressed: () {
                // Add the text as a bullet point
                setState(() {
                  lines.add('* ${bulletPointController.text}');
                  bulletPointController.clear();
                });
              },
              child: Text('Add Bullet Point'),
            ),
            const SizedBox(height: 16),
            if (isDrawingMode)
              Expanded(
                child: Container(
                  child: const Center(
                    child: Text('Drawing Feature'),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: lines.length,
                itemBuilder: (context, index) {
                  return Text(lines[index]);
                },
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: checklistItems.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: TextField(
                    controller: checklistControllers[index],
                    decoration: InputDecoration(hintText: 'Checklist item ${index + 1}'),
                  ),
                  value: checklistItems[index],
                  onChanged: (value) {
                    setState(() {
                      checklistItems[index] = value!;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: isDrawingMode
          ? null
          : BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            IconButton(
              icon: Icon(Icons.remove),
              tooltip: 'Decrease Font Size',
              onPressed: () {
                setState(() {
                  fontSize = (fontSize - 2.0).clamp(12.0, double.infinity);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.format_size),
              tooltip: 'Change Font Size',
              onPressed: () {
                setState(() {
                  fontSize += 2.0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.image),
              tooltip: 'Import Photo',
              onPressed: importPhoto,
            ),

            IconButton(
              icon: Icon(Icons.check_box),
              tooltip: 'Add Checklist',
              onPressed: addChecklistItem,
            ),

            IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Toggle Drawing Mode',
              onPressed: toggleDrawingMode,
            ),
          ],
        ),
      ),
    );
  }

  // Import Photo Functionality
  Future<void> importPhoto() async {
    // Implement your photo import logic here
  }

  // Add Bullet Points Functionality
  void addBulletPoint() {
    setState(() {
      lines.add('* ');
    });
  }

  // Add Checklist Item Functionality
  void addChecklistItem() {
    setState(() {
      checklistItems.add(false);
      checklistControllers.add(TextEditingController());
    });
  }

  // Toggle Drawing Mode Functionality
  void toggleDrawingMode() {
    setState(() {
      isDrawingMode = !isDrawingMode;
    });
  }
}
