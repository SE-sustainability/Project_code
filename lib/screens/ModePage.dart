import 'package:flutter/material.dart';
import 'RemindersPage.dart';
import 'ModePageOptions.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:coursework_project/screens/ModePageOptions.dart';
// import 'firebase_options.dart';
// import 'package:firebase_analytics/firebase_analytics.dart'
// import 'Backend/modes.dart';
// import 'note.dart'; // Import the Note class


class ModePage extends StatefulWidget {
  //Add connection property
  @override
  _ModePageState createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  final List<Mode> modes = [];

  void modeHandler(int mode_id) {
    print("Selected mode: $mode_id");
  }

  @override
  void initState() {
    super.initState();
  }
  Future<void> _navigateToModeOption({Mode? modeToEdit}) async {
    final editedMode = await Navigator.push<Mode?>(
      context,
      MaterialPageRoute(
        builder: (context) => ModePageOptions(mode: modeToEdit),
      ),
    );

    if (editedMode != null) {
      if (modeToEdit != null) {
        final index = modes.indexWhere((mode) => mode == modeToEdit);
        if (index != -1) {
          setState(() {
            modes[index] = editedMode;
          });
        }
      } else {
        if (_validateModeData(editedMode)) {
          setState(() {
            modes.add(editedMode);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please provide all mode details.'),
            ),
          );
        }
      }
    }
  }
  void _navigateToReminderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CreateNoteScreen()), //mode_id: mode_id),
    );
  }

  void _deleteMode(Mode mode) {
    setState(() {
      modes.remove(mode);
    });
  }

  void _navigateToEditMode(Mode mode) async {
    Mode? editedMode = await Navigator.push<Mode>(
      context,
      MaterialPageRoute(
        builder: (context) => ModePageOptions(mode: mode),
      ),
    );

    if (editedMode != null) {
      setState(() {
        // Find the index of the mode being edited and update it with the edited mode
        int index = modes.indexWhere((m) => m == mode);
        if (index != -1) {
          modes[index] = editedMode;
        }
      });
    }
  }

  bool _validateModeData(Mode mode) {
    return mode.description.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders App'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        padding: const EdgeInsets.all(16.0),
        children: modes.map((mode) {
          return _buildModeCard(mode); // Use _buildModeCard with Mode object
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _navigateToModeOption();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildModeCard(Mode mode) {
    return GestureDetector(
      onTap: () {
        // Handle mode selection here
        _navigateToReminderPage();
        // modeHandler(mode.id);
        print("Selected mode: ${mode.description}");
      },
      child: Card(
        color: mode.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        child: Stack(
          children: [
            Center(
            child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                mode.icon,
                size: 40.0,
                color: Colors.white,
              ),
              const SizedBox(height: 8.0),
              Text(
                mode.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit page
                    _navigateToEditMode(mode);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Delete mode
                    _deleteMode(mode);
                  },
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
   }
  }
