import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework_project/services/reminder_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class NewReminderScreen extends StatefulWidget {
  const NewReminderScreen({super.key});

  @override
  _NewReminderScreenState createState() => _NewReminderScreenState();
}

class _NewReminderScreenState extends State<NewReminderScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  // final TextEditingController _priority = TextEditingController();

  final ReminderService _databaseService = ReminderService();

  XFile? _imageFile;
  DateTime? _dateTime;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = image;
    });
  }

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _dateTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<void> addReminderDetails(String title, bool completed,
      String description, DateTime dateTime) async {
    Timestamp timestamp = Timestamp.fromDate(dateTime);
    await FirebaseFirestore.instance.collection('reminders').add({
      'title': title,
      'completed': completed,
      'description': description,
      'dateTime': timestamp
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'New Reminder',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _title,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _description,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Notes',
                    border: OutlineInputBorder(),
                    labelText: 'Notes',
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('Date & Time'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: _pickDateTime,
                ),
                ListTile(
                  leading: Icon(Icons.location_on), // Location icon
                  title: Text('Location'), // Location label
                  trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: () async {
                    // Handle location selection
                    LocationPermission permission =
                        await Geolocator.requestPermission();
                    if (permission == LocationPermission.always ||
                        permission == LocationPermission.whileInUse) {
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      // Do something with the obtained position
                      print(
                          'Latitude: ${position.latitude}, Longitude: ${position.longitude}');
                    } else {
                      // Handle the case when location permission is not granted
                      // You can show a dialog or request permission again
                      print('Location permission not granted.');
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.priority_high), // Priority icon
                  title: const Text('Priority'), // Priority label
                  trailing: const Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: () {
                    // Handle priority selection
                    // You can show a dropdown or dialog for priority options
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera), // Camera icon
                  title: const Text('Take Picture'), // Take Picture label
                  trailing: const Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: _pickImage, // Call the pick image function on tap
                ),
                _imageFile != null
                    ? Image.file(
                        File(_imageFile!.path),
                        height: 100,
                        width: 100,
                      )
                    : Container(),
                const ListTile(
                  leading: Text(
                    'Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reminders',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                Align(
                    alignment: const Alignment(0.0, 0.9),
                    child: MaterialButton(
                        onPressed: () {
                          String title = _title.text.trim();
                          String description = _description.text.trim();
                          bool completed = false;
                          if (title.isNotEmpty) {
                            addReminderDetails(
                                title, completed, description, _dateTime!);
                            _title.clear();
                            _description.clear();
                            setState(() {
                              _dateTime =
                                  null; // Clear _dateTime after adding the reminder
                            });
                          }
                        },
                        color: Color.fromARGB(245, 176, 67, 154),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color.fromARGB(255, 0, 0, 0),
                        // height: screenHeight * 0.1,
                        // minWidth: screenWidth * 0.14,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: const Text(
                          'SAVE',
                        ))),
              ],
            ),
          ),
        ));
  }
}
