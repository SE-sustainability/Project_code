import 'screens/note.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
// import 'note.dart';// Adjusted import statement

// void main() async

late Box<Note> box;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();   //HIVE SETUP
  await Hive.initFlutter();   //HIVE SETUP
  Hive.registerAdapter(NoteAdapter());
  box = await Hive.openBox<Note>('notes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), // Adjusted reference to HomeScreen
    );
  }
}
