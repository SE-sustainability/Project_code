import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  // const ReminderScreen({super.key});

  final String reminderId;
  final String title;
  String description;

  // const ReminderScreen({required this.reminderId, required this.title});
  ReminderScreen(
      {Key? key,
      required this.reminderId,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  TextEditingController _description = TextEditingController();
  // final TextEditingController _priority = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (widget.reminderId.isNotEmpty) {
      _loadReminderOptions(id: widget.reminderId);
    }
  }

  XFile? _imageFile;
  DateTime? _dateTime;

   Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: const Text('Select an image source'),
          actions: <Widget>[
            TextButton(
              child: const Text('Gallery'),
              onPressed: () async {
                final XFile? galleryImage =
                await _picker.pickImage(source: ImageSource.gallery);
                if (galleryImage != null) {
                  Navigator.of(context).pop(galleryImage);
                }
              },
            ),
            TextButton(
              child: const Text('Camera'),
              onPressed: () async {
                final XFile? cameraImage =
                await _picker.pickImage(source: ImageSource.camera);
                if (cameraImage != null) {
                  Navigator.of(context).pop(cameraImage);
                }
              },
            ),
          ],
        );
      },
    );

    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future<Map<String, dynamic>> _loadReminderOptions(
      {required String id}) async {
    try {
      DocumentSnapshot reminderSnapshot =
          await _firestore.collection('reminders').doc(id).get();

      if (reminderSnapshot.exists) {
        Map<String, dynamic> data =
            reminderSnapshot.data() as Map<String, dynamic>;
        return data;
      } else {
        // Reminder with the given ID does not exist
        return {};
      }
    } catch (e) {
      print('Error loading reminder options: $e');
      // Return an empty map in case of an error
      return {};
    }
  }

  Future<void> _updateDescription(String newDescription) async {
    try {
      await FirebaseFirestore.instance
          .collection('reminders')
          .doc(widget.reminderId)
          .update({'description': newDescription});
      setState(() {
        widget.description = newDescription;
      });
    } catch (e) {
      print('Error updating description: $e');
      // Handle errors
    }
  }

  Future<void> _updateDateTime(DateTime newDateTime) async {
    try {
      await FirebaseFirestore.instance
          .collection('reminders')
          .doc(widget.reminderId)
          .update({'dateTime': newDateTime});
      setState(() {
        _dateTime = newDateTime;
      });
    } catch (e) {
      print('Error updating date and time: $e');
    }
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
        DateTime newDateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        await _updateDateTime(newDateTime);
      }
    }
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
            widget.title,
            style: const TextStyle(
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
                const SizedBox(height: 16),
                TextField(
                  controller: _description,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Notes',
                    border: OutlineInputBorder(),
                    labelText: widget.description,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text('Date & Time'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _pickDateTime,
                ),
                ListTile(
                  leading: const Icon(Icons.location_on), // Location icon
                  title: const Text('Location'), // Location label
                  trailing: const Icon(Icons.arrow_forward_ios), // Arrow icon
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
                  leading: Icon(Icons.priority_high), // Priority icon
                  title: Text('Priority'), // Priority label
                  trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
                  onTap: () {
                    // Handle priority selection
                    // You can show a dropdown or dialog for priority options
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera), // Camera icon
                  title: Text('Take Picture'), // Take Picture label
                  trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
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
                        onPressed: () async {
                          String title = widget.title.trim();
                          String newDescription = _description.text.trim();
                          if (newDescription.isNotEmpty) {
                            await _updateDescription(newDescription);
                          }
                          if (title.isNotEmpty) {
                            _loadReminderOptions(id: widget.reminderId);
                          }
                          if (_dateTime != null) {
                            await _updateDateTime(_dateTime!);
                          }
                          ;
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
                        )))
              ],
            ),
          ),
        ));
  }
}
