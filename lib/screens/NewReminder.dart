import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework_project/services/reminder_services.dart';
import 'package:coursework_project/services/reminderOptions_services.dart';
import 'package:coursework_project/screens/Backend/reminder_options.dart';

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
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();

  final ReminderService _databaseService = ReminderService();
  final ReminderOptionsService _reminderOptionsService =
      ReminderOptionsService();

  Future<void> addReminderDetails(String title, bool completed) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .add({'title': title, 'completed': completed});
  }

  Future<void> _addReminderOptionsDetails() async {
    Reminder_Options reminderOptions =
        Reminder_Options(title: _title.text, description: _description.text);
    await _reminderOptionsService.addReminderOptions(reminderOptions);
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: ((context) => CreateNoteScreen(title: _title))));
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
              leading: Icon(Icons.date_range), // Date icon
              title: Text('Date'), // Date label
              trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
              onTap: () async {
                // Handle date selection
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  _date.text = selectedDate.toString();
                  // Do something with the selected date
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time), // Time icon
              title: Text('Time'), // Time label
              trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
              onTap: () async {
                // Handle time selection
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  // Do something with the selected time
                  _time.text = selectedTime.toString();
                }
              },
            ),
            TextField(
              controller: TextEditingController(
                text: '${_date.text} ${_time.text}',
              ),
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Selected Date & Time',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    // _date.clear();
                    // _time.clear();
                  },
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on), // Location icon
              title: Text('Location'), // Location label
              trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
              onTap: () {
                // Handle location selection
                // You can open a map or location picker here
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.priority_high), // Priority icon
            //   title: Text('Priority'), // Priority label
            //   trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
            //   onTap: () {
            //     // Handle priority selection
            //     // You can show a dropdown or dialog for priority options
            //   },
            // ),
            Align(
                alignment: const Alignment(0.0, 0.9),
                child: MaterialButton(
                    onPressed: () {
                      String title = _title.text.trim();
                      String description = _description.text.trim();
                      // DateTime selectedDate = DateTime.parse(_date.text);
                      // TimeOfDay selectedTime = TimeOfDay.fromDateTime(
                      //     DateTime.parse('1970-01-01 ${_time.text}'));
                      bool completed = false;
                      if (title.isNotEmpty) {
                        addReminderDetails(title, completed);
                        _addReminderOptionsDetails();
                        // addReminderOptionsDetails(
                        //     title,
                        //     description,
                        //     Timestamp.fromDate(selectedDate),
                        //     Timestamp.fromDate(DateTime(
                        //         selectedDate.year,
                        //         selectedDate.month,
                        //         selectedDate.day,
                        //         selectedTime.hour,
                        //         selectedTime.minute)));
                        _title.clear();
                        _description.clear();
                        // _date.clear();
                        // _time.clear();
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'SAVE',
                    )))

            // ListTile(
            //   leading: Text(
            //     'Reminder Options',
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   trailing: Icon(Icons.arrow_forward_ios),
            // ),
            // ListTile(
            //   leading: Text(
            //     'Mode',
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   trailing: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Text(
            //         'Reminders',
            //         style: TextStyle(
            //           color: Colors.green,
            //         ),
            //       ),
            //       Icon(Icons.arrow_forward_ios),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
