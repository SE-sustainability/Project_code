import 'package:flutter/material.dart';
import 'package:coursework_project/screens/Backend/settings.dart';
import 'package:coursework_project/services/settings_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


String colour = "white";
int fontSize = 20;

class CreateSettingsScreen extends StatefulWidget {
  //const CreateSettingsScreen({super.key});

  @override
  _CreateSettingsScreenState createState() => _CreateSettingsScreenState();
}

class _CreateSettingsScreenState extends State<CreateSettingsScreen> {

  String? _initialColor;
  double? _initialFontSize;

  String? _color;
  double? _fontSize;

  final SettingsService _databaseService = SettingsService();
  final List<AppSettings> app_settings = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
    _getSettingsData();
    _initializeFirebase();
    _fetchSettingsFromFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _fetchSettingsFromFirebase() async {
    final settingsDoc = await FirebaseFirestore.instance
        .collection('settings')
        .doc('lglhw4pN0FNw9LaOiVqX')
        .get();

    if (settingsDoc.exists) {
      final settingsData = settingsDoc.data();
      setState(() {
        _initialColor = settingsData?['colour'];
        _initialFontSize = settingsData?['font_Size']?.toDouble();

        _color = _initialColor;
        _fontSize = _initialFontSize;
      });
    }
  }

  Future<void> _fetchSettings() async {
    final fetchedSettings = await _databaseService.getSettings().first;

    final settingsList = fetchedSettings.docs.map((doc){
      final data = doc.data() as Map<String, dynamic>;
      return AppSettings.fromJson(data);
    }).toList();

    setState(() {
      app_settings.addAll(settingsList);
    });
  }


  String _dropdownValue = colour.toString();

  var _items = [
    "white",
    "grey",
    "green",
    "blue",
    "yellow"
  ];

  double  _currentSliderValue = fontSize.toDouble();

  Color getBackgroundColor(color){
    if (color == "white"){
      return Colors.white;
    }
    else if (color == "grey"){
      return Colors.black87;
    }
    else if (color == "green"){
      return Colors.green;
    }
    else if (color == "blue"){
      return Colors.blue;
    }
    else {
      return Colors.yellow;
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


  Color getTextColor(color){
    return Colors.white;
  }

  Color getAppBarColor(color){
    if (color == "white"){
      return Colors.blue;
    }
    else if (color == "grey"){
      return Colors.white12;
    }
    else if (color == "green"){
      return Colors.blue;
    }
    else if (color == "blue"){
      return Colors.black12;
    }
    else {
      return Colors.white12;
    }
  }

  Color getDropdownTextColor(color){
    return Colors.black;
  }

  void editSetting(String? newColour, double? newSize) async {
    setState(() {
      _color = newColour;
      _fontSize = newSize;
    });

    final settingsData = {
      'colour': newColour,
      if (newSize != null) 'font_Size': newSize,
    };

    await FirebaseFirestore.instance
        .collection('settings')
        .doc('lglhw4pN0FNw9LaOiVqX')
        .set(settingsData);
  }

  void _getSettingsData() async {
    FirebaseFirestore.instance
        .collection('settings')
        .doc('lglhw4pN0FNw9LaOiVqX')
        .snapshots()
        .listen((settingsData) {

      setState(() {
        colour = settingsData['colour'];
        fontSize = settingsData['font_Size'];
        _currentSliderValue = settingsData['font_Size']?.toDouble() ?? 20.0;
      });
    });
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
        backgroundColor: _color != null ? getBackgroundColor(_color!) : Colors.white,
        appBar: AppBar (
          backgroundColor: _color != null ? getAppBarColor(_color!) : Colors.blue,
          title: Text(
            'Settings',
            style: TextStyle(
              color: _color != null ? getTextColor(_color!) : Colors.white,
              fontSize: _fontSize ?? 20.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        margin: const EdgeInsets.all(10.0),
                        color: getAppBarColor(_color),
                        child: ListTile(
                          title: Text("Theme", style: TextStyle(color: getTextColor(_color), fontSize: _fontSize)),
                          trailing: Icon(Icons.color_lens, color: getTextColor(_color)),
                        )
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                      child: Center(
                          child: DropdownButton(
                            items: _items.map((String item){
                              return DropdownMenuItem(
                                  value: item,
                                  child: Text(item)
                              );
                            }).toList(),
                            onChanged: (String? newValue){

                              setState(() {
                                _dropdownValue = newValue!;
                              });

                              editSetting(newValue!, _currentSliderValue);

                              print(colour.toString());
                              print(fontSize);
                            },
                            value: _color,
                            borderRadius: BorderRadius.circular(10),
                            style: TextStyle(
                                fontSize: _currentSliderValue,
                                color: getDropdownTextColor(_color)
                            ),
                            underline: Container(),
                          )
                      )
                  ),

                  Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      margin: const EdgeInsets.all(10.0),
                      color: getAppBarColor(_color),
                      child: ListTile(
                        title: Text("Font Size", style: TextStyle(color: getTextColor(_color), fontSize: _fontSize)),
                        trailing: Text(_fontSize.toString(), style: TextStyle(color: getTextColor(_color))),
                      )
                  ),

                  Slider(
                    value: _currentSliderValue,
                    max: 50,
                    min: 10,
                    divisions: 4,
                    label: _currentSliderValue.round().toString(),
                    activeColor: getAppBarColor(_color),
                    inactiveColor: getAppBarColor(_color),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;

                        editSetting(_dropdownValue, value);
                      });
                    },
                  )

                ]
            )
        )
    );
  }
/*
  Widget _settingsData(){
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseService.getSettings(),
        builder: (context, snapshot) {
          List _settings = snapshot.data?.docs ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.data == null) {
            return const Center(child: Text("Settings not found"));
          }
          if (_settings.isEmpty) {
            return const Center(
              child: Text("Settings not found"),
            );
          }
          return ListView.builder(
            itemCount: _settings.length,
            itemBuilder: (context, index) {
              AppSettings _bgSetting = _settings[index].data();
              String settingId =
                  _settings[index].id;
              return Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: Center(
                      child: DropdownButton(
                        items: _items.map((String item){
                          return DropdownMenuItem(
                              value: item,
                              child: Text(item)
                          );
                        }).toList(),
                        onChanged: (String? newValue){

                          setState(() {
                            _dropdownValue = newValue!;
                          });

                          editSetting(newValue, _currentSliderValue);

                        },
                        value: _dropdownValue,
                        borderRadius: BorderRadius.circular(10),
                        style: TextStyle(
                            fontSize: _currentSliderValue,
                            color: getDropdownTextColor(_dropdownValue)
                        ),
                        underline: Container(),
                      )
                  )
              );
            },
          );

        }));
  }
*/
}
