import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework_project/screens/Backend/reminder.dart';
// import 'package:coursework_project/services/reminder_provider';
import 'package:coursework_project/services/reminder_services.dart';
import 'Reminder_OptionsPage.dart';
import 'package:flutter/material.dart';
import 'NewReminder.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CreateNoteScreen extends StatefulWidget {
  // final String reminderId;
  // final String title; // Add title parameter

  // const CreateNoteScreen({required this.reminderId, required this.title});

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final ReminderService _databaseService = ReminderService();

  double fontSize = 16.0;
  List<String> lines = [];
  List<bool> checklistItems = [];
  List<TextEditingController> checklistControllers = [];

  @override
  void initState() {
    super.initState();
  }

  void _navigateToReminderOptionsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewReminderScreen()),
    );
  }

  Future<void> _addReminder() async {
    Reminder newReminder = Reminder(title: 'New Reminder', completed: false);
    String reminderId = await _databaseService.addReminder(newReminder);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ReminderScreen(
    //       reminderId: widget.reminderId,
    //       title: widget.title,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('REMINDERS'),
      ),
      body: _buildUI(),
      // creating a new reminder/navigating to reminder_options page
      floatingActionButton: FloatingActionButton(
        onPressed: (_navigateToReminderOptionsPage),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _remindersListView(),
      ],
    ));
  }

  Widget _remindersListView() {
    // final reminders = Provider.of<ReminderProvider>(context);
    return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.80,
        width: MediaQuery.sizeOf(context).width,
        child: StreamBuilder(
            stream: _databaseService.getReminders(),
            builder: (context, snapshot) {
              List reminders = snapshot.data?.docs ?? [];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.data == null) {
                return Center(child: Text("No reminders found"));
              }
              if (reminders.isEmpty) {
                return const Center(
                  child: Text("Add a reminder"),
                );
              }

              // print(reminders);
              return ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    Reminder reminder = reminders[index].data();
                    String reminderId =
                        reminders[index].id; //Get id of reminder
                    // print(reminderId);'#;
                    // print(reminder);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: ListTile(
                        title: Text(reminder.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: reminder.completed,
                              onChanged: (value) {
                                Reminder updatedReminder = reminder.copyWith(
                                    completed: !reminder.completed);
                                _databaseService.updateReminder(
                                    reminderId, updatedReminder); //checkbox.
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _databaseService.deleteReminder(
                                    reminderId); // deletes reminders
                              },
                            ),
                          ],
                        ),
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReminderScreen(
                                    reminderId: reminderId,
                                    title: reminder.title)),
                          );
                        }, // navigate to reminder options to update current reminder
                      ),
                    );
                  });
            }));
  }
}

