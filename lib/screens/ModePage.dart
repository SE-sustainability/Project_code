import 'package:flutter/material.dart';
import 'RemindersPage.dart';
import 'ModePageOptions.dart';
import 'package:coursework_project/screens/Backend/modes.dart';
import 'package:coursework_project/services/mode_services.dart';
import 'settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ModePage extends StatefulWidget {
  //Add connection property
  @override
  _ModePageState createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  final List<Mode> modes = [];
  final ModeService _modeService = ModeService();

  String? _backgroundColor;
  double? _fontSize;

  @override
  void initState() {
    super.initState();
    _fetchModes();
    _listenToSettingsChanges();
  }


  void _listenToSettingsChanges() {
    FirebaseFirestore.instance
        .collection('settings')
        .doc('lglhw4pN0FNw9LaOiVqX')
        .snapshots()
        .listen((settingsData) {
      setState(() {
        _backgroundColor = settingsData['colour'];
        _fontSize = settingsData['font_Size']?.toDouble();
      });
    });
  }

  Future<void> _fetchModes() async {

    List<Mode> fetchedModes = await _modeService.getModes();
    setState(() {
      modes.addAll(fetchedModes);
    });
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
          builder: (context) =>   CreateNoteScreen()), //mode_id: mode_id),
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
        int index = modes.indexWhere((m) => m.id == mode.id);
        if (index != -1) {
          modes[index] = editedMode.copyWith(id: mode.id); // Ensure the mode ID is preserved
          _modeService.updateMode(mode.id, editedMode.copyWith(id: mode.id));
        }
      });
    }
  }
  bool _validateModeData(Mode mode) {
    return mode.description.isNotEmpty;
  }



  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _backgroundColor != null
        ? getBackgroundColor(_backgroundColor!)
        : Colors.blueGrey;

    double fontSize = _fontSize ?? 16.0;

    return Scaffold(
      appBar: AppBar(
        title:  Text(
            'Reminders App',
            style: TextStyle(fontSize: fontSize),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  CreateSettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body:GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        padding: const EdgeInsets.all(16.0),
        children: modes.map((mode) {
          return _buildModeCard(mode,fontSize); // Use _buildModeCard with Mode object
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

  Widget _buildModeCard(Mode mode,double fontSize) {
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
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
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
  Color getBackgroundColor(String color) {
    switch (color) {
      case "white":
        return Colors.white;
      case "grey":
        return Colors.grey;
      case "green":
        return Colors.green;
      case "blue":
        return Colors.blue;
      case "yellow":
        return Colors.yellow;
      default:
        return Colors.blueGrey;
    }
  }
  // Color getBackgroundColor(String color) {
  //   switch (color) {
  //     case "white":
  //       return Colors.white;
  //     case "black":
  //       return Colors.black;
  //     case "red":
  //       return Colors.red;
  //     case "green":
  //       return Colors.green;
  //     case "blue":
  //       return Colors.blue;
  //     case "yellow":
  //       return Colors.yellow;
  //     case "orange":
  //       return Colors.orange;
  //     case "pink":
  //       return Colors.pink;
  //     case "purple":
  //       return Colors.purple;
  //     case "teal":
  //       return Colors.teal;
  //     case "cyan":
  //       return Colors.cyan;
  //     case "brown":
  //       return Colors.brown;
  //     case "grey":
  //       return Colors.black87;
  //     case "blueGrey":
  //       return Colors.blueGrey;
  //     default:
  //       return Colors.yellow;
  //   }
  // }
}



