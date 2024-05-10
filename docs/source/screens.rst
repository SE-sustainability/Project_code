Screens
=====
There are 5 different files for each of the 5 different screens within our app; Mode Page (ModePage.dart), Mode Page Options (ModePageOptions.dart), Reminders Page (RemindersPage.dart), Reminder Page Options (ReminderPage_Options.dart), Reminder Details (ReminderDetails.dart). Each Page will link to other Pages which will be detailed below. The page which will be opened when the app is run will be the Mode Page.

.. _installation:

Mode Page
------------
The first page which is opened when the app is Run is the "Mode Page" This page allows the user to choose which mode the reminders are in. When the app is launched for the first time there will be no options for modes that you can have. To add a reminder mode, you will have to click the widget in the bottom right of the screen which resembles a plus in a circle which will direct the user to the "Mode Page Options", allowing the user to create a mode which will be accessible on the "Mode Page". When Modes Have been created there will be the modes show up on the "Mode Page" as clickable widgets, when clicked it will take the user to the unique reminders page. The Mode Page may also appear different to the user depending on how the user has the settings within the setting page.

**Interactive Widgets**

There are interactive widgets within the Mode Page. The Options widget, the modes widgets and the general settings widget for the app.

*Options Widget and Settings Widget*

Both of these widgets are hard-coded into the app, however, they have different functionality. The Options Widget is one of the 2 possible types of interactive widgets on this page. This widget will appear the same for all users, it allows the user to go to the mode options page, and edit the modes found within the mode page such as add, edit or delete. The settings widget resembles a cog in the top right corner, it will open up the settings page, allowing the user to change the appearance of the app. Both of these specific widgets will take the user to the specific pages when clicked, The Options widget will take the user to the Mode Options Page and the settings widget will take the user Within the code both of these widgets are built together in one widget scaffold.

Below is the code for the settings wiget:

.. code-block:: dart

  @override
  IconButton(
    tooltip: 'Settings',
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateSettingsScreen()),
      );
    },
    icon: const Icon(Icons.settings),
  ),

Below is the code for the Mode Options widget:

.. code-block:: dart

  FloatingActionButton(
    onPressed: () async {
      _navigateToModeOption();
    },
     child: const Icon(Icons.add),
  ),
      


*Mode Widgets*

The widgets which are created within the mode widget will appear different to every user as they are customised to how the user has added them.  When each mode is clicked the app will navigate to the specific mode page which will have the reminders for that mode. This is achieved by the app retrieving the mode settings from the database based on the user's preferences. The modes are sorted into this database with :samp:`mode.id` as the primary key, which is also used as a foreign key for reminders to associate them with a mode. The name of the mode is stored under :samp:`mode.description`. The rest of the columns within the database are associated with the appearance of the widget for the mode: :samp:`mode.color` for the colour and :samp:`mode.icon` for the icon. In the bottom right of the widget there is an edit button, which takes users to a page to edit the details of the mode. Next to the edit icon, there is a delete icon which will delete the mode by deleting the row in the database so it will no longer show up for the users. This widget is the most code-heavy and difficult to implement.


The code which takes the user to the specific mode using the mode's id:

.. code-block:: dart

    Widget _buildModeCard(Mode mode) {
      return GestureDetector(
        onTap: () {
          // Handle mode selection here
          _navigateToReminderPage();
          // modeHandler(mode.id);
          print("Selected mode: ${mode.description}");
        },

Code for the Specific Edit and delete widgets which are found in the bottom right of each mode widget:

.. code-block:: dart

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
    )


Full block of code for the mode widget:

.. code-block:: dart

  Widget _buildModeCard(Mode mode, double fontSize) {
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
              child: Column(
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
                    style: TextStyle(
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


Below is the full code for "ModePage.dart"

.. code-block:: dart

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
            builder: (context) => CreateNoteScreen(),
          ),
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
            title: Text(
              'Reminders App',
              style: TextStyle(fontSize: fontSize),
            ),
            actions: [
              IconButton(
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateSettingsScreen()),
                  );
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          body: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            padding: const EdgeInsets.all(16.0),
            children: modes.map((mode) {
              return _buildModeCard(mode, fontSize);
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              _navigateToModeOption();
            },
            child: Icon(Icons.add),
          ),
        );
      }
    
      Widget _buildModeCard(Mode mode, double fontSize) {
        return GestureDetector(
          onTap: () {
            _navigateToReminderPage();
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
                  child: Column(
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
                        style: TextStyle(
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
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToEditMode(mode);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
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
    }





Settings Screen
---------------
Once The user has clicked the settings icon the app will take the user to the settings page, which allows the user to change the appearance of the app. The user can change the size of the text and the theme (background and font colour) of the app, which will change across the app. This is done by updating a database, allowing the change to be implemented universally throughout the app. The specific customisation was done as it allows accessibility; changing the text size allows people who have poor eyesight to read the app easier and therefore have an easier time navigating our app, and allows users to change the theme (which is a different background colour and the text colour changing to a contrasting colour) allows people who have visual stress or learning disabilities such as dyslexia have an easier time reading as white can be a very harsh background colour. The default setting for the app is the theme being white (white background and black text) with size 20 font.

*Theme Widget*

The theme within our app is selected by a dropdown menu, allowing the users to choose from the preselected list of themes. This will change the background and text colour. The themes are stored within :samp:`_items` list, allowing easier implementation of new themes in the future  The list of the current themes is: white, grey, green, blue and yellow. A new theme is selected by clicking an option on the dropdown menu which will trigger a callback called :samp:`onChanged`, which will trigger the :samp:`editsetting` function. This function updates the Firebase Firestore database by querying the :samp:`settings` collection then it will set the :samp:`_initialColor` to the current theme. The function will immediately change the appearance on the Settings page, as if it just updated the database the screen would need to refresh for the settings to come into effect.

The code for the drop down menu is below:

.. code-block:: dart

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
            color: getDropdownTextColor(_color)
          ),
          underline: Container(),
        )
      )
    ),


*Text size Widget*

The font size can be changed across the app by using a slider, the default size of the text within the app (and when the slider is located in the middle) is 20. The maximum for this slider is 50 and the minimum is 10, there are 4 divisions in the slider, allowing the user to change the text size. The new text size is changed by the user dragging the slider, this triggers the callback called :samp:`onChanged`, which will update the function :samp:`_currentSliderValue` alongside triggering :samp:`setState()` which updates the current screen to the new text size. This additionally triggers the :samp:`editsetting` function, which updates the Firebase Firestore database by querying the :samp:`settings` collection then it will set the :samp:`_fontSize` to the current text size, so the text size is implemented across the app equally.

The code for the Slider widget is below:

.. code-block:: dart

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

*Storing app settings*

The app makes sure that the settings are consistent across the whole app. The app stores the settings in a database called Firebase. It's used as it allows the app to update in real-time, which allows the settings to be implemented extremely quickly. The database is updated every time the user changes any setting, this happens because the selection of an item on the dropdown menu or sliding the slider triggers the :samp:`editsetting` function. This function tells the database to query the collection named :samp:`settings` within the document called "lglhw4pN0FNw9LaOiVqX", it then sets either the :samp:`_initialColor` or samp:`_fontSize` to the new colour or new text size respectfully.

Below is the code for storing the changed setting into the database:

.. code-block:: dart

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

*Implementation accross the app*

Whenever a screen is loaded within the app, one of the first things that the code does is access the Firebase database, by running the :samp:`_listenToSettingsChanges()` which in turn runs :samp:`snapshots()`. function. This 'listens' to changes in the collection called :samp:`settings`, in the document with the id of "lglhw4pN0FNw9LaOiVqX". When there is a change in the data within the collection, the code will get Firebase to retrieve the new value(s) and in turn update the local variables named :samp:`_backgroundColor` and :samp:`_fontSize`. These variables are then used in :samp:`build()` methods which is what the user will see.

Below is the code which shows how the database is accessed when data changes - this code is found in every other screen apart from settings:

.. code-block:: dart

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

Below is the full code for the settings screen:

.. code-block:: dart

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

      var _items = [        "white",        "grey",        "green",        "blue",        "yellow"      ];

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
    }

Mode Page Options
-----------------

The user may access this screen in one of two ways, either by pressing the edit icon on a preexisting mode or by pressing the Mode Options widget in the bottom right of the corner on the "mode Page". This page has 3 inputs to allow the user to customise how the mode looks these being; a text box for the mode description, and drop-down grids for the icon and colour selection. If the user is editing a mode then what was saved in the database for that particular mode will be filled out, using the :samp:`mode.id`. If the user has decided to create a new mode the default page will show. this is; an empty text box for the description, the icon is set to alarm and the colour is blue. Once the desired information has been inputted, the user can press the save icon. If the user is editing the mode, the entry in the database will be updated according to the :samp:`mode.id` whereas if the user is creating a new mode, the data will be saved to the database using the next :samp:`mode.id` which is available.

*editing vs creating a mode*

Because this screen is used to create as well as edit modes, it's important to be able to differentiate the two. When the screen is loaded, :samp:`initState()` is run to determine what mode it is and therefore what the screen should look like. If :samp:`widget.mode` is null then the screen will be in creation mode, this means that the widgets will be in the default options, allowing a user to create a mode. When a user wants to edit a mode, :samp:`widget.mode` won't be null as when the edit icon is pressed, the mode.id will be passed into the screen, using the :samp: `ModePageOptions` class. due to :samp:`widget.mode` being not null and having the value of the :samp:`mode.id` of the mode that the user wants to edit, the rest of the :samp:`if` statement will fill in the description, icon and colour with what the mode was unedited.

Below is the code which sees if and information has been transfered to this screen:

.. code-block:: dart

  class ModePageOptions extends StatefulWidget {
    final Mode? mode;
  
    ModePageOptions({required this.mode});
  
    @override
    _ModePageOptionState createState() => _ModePageOptionState();
  }

Below is the code which checks to see if :samp:`widget.mode` is null:

.. code-block:: dart

  void initState() {
    super.initState();
    if (widget.mode != null) {
      _descriptionController.text = widget.mode!.description;
      _selectedIcon = widget.mode!.icon;
      _selectedColor = widget.mode!.color;
    }
  }


*Mode Description Text field*

This text field will either apear with an existing mode description, the one the user would like to edit, or be blank if the user is creating a new mode. This text field will be validated when the user attempts to save, as the mode must have a description. 

The code for the text field is below:

.. code-block:: dart

  TextField(
    controller: _descriptionController,
    decoration: const InputDecoration(
    labelText: 'Description',
    ),
  ),

*Icon Drop Down*

This widget allows the user to choose an icon to represent the mode. This is represented by a grid in which the user can choose from predefined icons. The :samp:`_buildIconGrid` method arranges the icons into a grid for the user to choose from.

Below is the code for the icon widget:

.. code-block: dart
  
  IconButton(
    icon: Icon(_selectedIcon),
    onPressed: () {
     _pickIcon(context);
    },
    iconSize: 40
  ),

Below is the code that rearranges the icons into a grid:

.. code-block:: dart

    Widget _buildIconGrid(BuildContext context) {
        List<IconData> icons = [            Icons.home,            Icons.work,            Icons.beach_access,            // List of icons in grid        ];
        return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery
                        .of(context)
                        .size
                        .height * 0.8 // Adjust the height as needed
                ),
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                    ),
                    itemCount: icons.length,
                    itemBuilder: (BuildContext context, int index) {
                        // Use the IconData at the current index
                        IconData iconData = icons[index];
                        return IconButton(
                            icon: Icon(iconData),
                            onPressed: () {
                                setState(() {
                                    _selectedIcon = iconData; // Update the selected icon
                                });
                                Navigator.of(context).pop(); // Close the dialog
                            },
                        );
                    },
                ),
            ),
        );
    }


*Colour Picker Drop Down*

The colour picker is programmed very similarly to the icon picker, only using colours instead of icons. The grid is built using the :samp:`_buildColorGrid`, when the user presses on the colour picker, the grid will appear. When the user presses on one of the colours, :samp:`_selectedColor` is triggered and the colour is updated.

Below is the code for the colour widget:

.. code-block:: dart

    void _pickColor(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pick a Color'),
                  const SizedBox(height: 16.0),
                  _buildColorGrid(context),
                ],
              ),
            ),
          );
        },
      );
    }


Below is the code for the Colour grid:

.. code-block:: dart

    Widget _buildColorGrid(BuildContext context) {
      List<Color> colors = [
        Colors.red,
        Colors.redAccent,
        // Long list of colours in same format.
      ];
    
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery
                .of(context)
                .size
                .height * 0.7, // Adjust the height as needed
          ),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemCount: colors.length,
            itemBuilder: (BuildContext context, int index) {
              // Use the Color at the current index
              Color color = colors[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color; // Update the selected color
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: color,
                ),
              );
            },
          ),
        ),
      );
    }

*Save Widget*

Depending on if the user had decided to edit a mode or create a new one, the widget will work slightly differently. However, the first step is the same, this being validating the inputs. For it is made sure that the Mode description text field is not empty. If it is empty the user will be unable to save the mode and there will be an error message. If it's not null, the program will then go on to save the mode. The function :samp:`_descriptionController` will first retrieve the Mode description, assigning it to a new 'mode' called :samp:`updatedMode` alongside the selected icon and colour. It next checks to see if :samp:`widget.mode` is null or not. If it is not null (edit mode), the existing mode (with the same :samp:`mode.id`) will be updated using the method :samp:`_modeService.updateMode()`. If it is null, a new mode will be created using the method :samp:`_modeService.addMode()`. The screen then exists to the previous page (Mode Page) with the new, updated data, using :samp:`Navigator.pop(context, updatedMode)`.

The code for the save widget is below:

.. code-block:: dart

    const SizedBox(height: 50),
    TextButton(
      onPressed: _saveMode,
      child: const Text('Save Mode',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),


Code for the saving function:

.. code-block:: dart

    void _saveMode() {
        String description = _descriptionController.text;
        Mode updatedMode = Mode(
            id: widget.mode != null ? widget.mode!.id : Uuid().v4(),
            description: description,
            icon: _selectedIcon,
            color: _selectedColor);
        if (widget.mode != null) {
            // Update existing mode
            _modeService.updateMode(widget.mode!.id, updatedMode);
        } else {
            // Create new mode
            _modeService.addMode(updatedMode);
        }
        Navigator.pop(context, updatedMode);
    }


Full code for the Screen:

.. code-block:: dart

    import 'package:flutter/material.dart';
    import 'package:coursework_project/screens/Backend/modes.dart';
    import 'package:coursework_project/services/mode_services.dart';
    import 'package:uuid/uuid.dart';
    
    
    class ModePageOptions extends StatefulWidget {
      final Mode? mode;
    
      ModePageOptions({required this.mode});
    
      @override
      _ModePageOptionState createState() => _ModePageOptionState();
    }
    
    class _ModePageOptionState extends State<ModePageOptions> {
      final ModeService _modeService = ModeService();
    
      final TextEditingController _descriptionController = TextEditingController();
      IconData _selectedIcon = Icons.alarm;
      Color _selectedColor = Colors.blue;
    
      void initState() {
        super.initState();
        if (widget.mode != null) {
          _descriptionController.text = widget.mode!.description;
          _selectedIcon = widget.mode!.icon;
          _selectedColor = widget.mode!.color;
        }
      }
    
      void _saveMode() {
        String description = _descriptionController.text;
        Mode updatedMode = Mode(
            id: widget.mode != null ? widget.mode!.id : Uuid().v4(),
            description: description,
            icon: _selectedIcon,
            color: _selectedColor);
        if (widget.mode != null) {
          // Update existing mode
          _modeService.updateMode(widget.mode!.id, updatedMode);
        } else {
          // Create new mode
          _modeService.addMode(updatedMode);
        }
        Navigator.pop(context, updatedMode);
      }
    
    
      @override
      void dispose() {
        _descriptionController.dispose();
        super.dispose();
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Mode'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Select Icon:',
                    style:
                    TextStyle(fontSize: 20)
                ),
                IconButton(
                    icon: Icon(_selectedIcon),
                    onPressed: () {
                      _pickIcon(context);
                    },
                    iconSize: 40
                ),
                const SizedBox(height: 20),
                const Text('Select Color:',
                    style:
                    TextStyle(
                        fontSize: 20)
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _pickColor(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: _saveMode,
                  child: const Text('Save Mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),),
                ),
              ],
            ),
          ),
        );
      }
    
      void _pickIcon(BuildContext context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text('Pick an Icon'),
                    const SizedBox(height: 16.0),
                    _buildIconGrid(context),
                  ],
                ),
              ),
            );
          },
        );
      }
    
      Widget _buildIconGrid(BuildContext context) {
        List<IconData> icons = [          Icons.home,          Icons.work,          Icons.beach_access,          Icons.directions_car,          Icons.accessibility_new,          Icons.menu_book,          Icons.school,          Icons.lightbulb,          Icons.fastfood_outlined,          Icons.coffee,          Icons.school,          Icons.lightbulb,          Icons.attach_money,          Icons.brush,          Icons.camera,          Icons.directions_bike,          Icons.directions_bus,          Icons.directions_boat,          Icons.directions_railway,          Icons.directions_run,          Icons.directions_walk,          Icons.event,          Icons.favorite,          Icons.home_work,          Icons.kitchen,          Icons.local_cafe,          Icons.local_gas_station,          Icons.local_hospital,          Icons.local_pharmacy,          Icons.local_pizza,          Icons.movie,          Icons.music_note,          Icons.shopping_basket,          Icons.shopping_cart,          Icons.sports_soccer,          Icons.star,          Icons.tag_faces,          Icons.terrain,          Icons.train,          Icons.work,        ];
    
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery
                    .of(context)
                    .size
                    .height * 0.8 // Adjust the height as needed
            ),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: icons.length,
              itemBuilder: (BuildContext context, int index) {
                // Use the IconData at the current index
                IconData iconData = icons[index];
                return IconButton(
                  icon: Icon(iconData),
                  onPressed: () {
                    setState(() {
                      _selectedIcon = iconData; // Update the selected icon
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              },
            ),
          ),
        );
      }
    
      void _pickColor(BuildContext context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Pick a Color'),
                    const SizedBox(height: 16.0),
                    _buildColorGrid(context),
                  ],
                ),
              ),
            );
          },
        );
      }
    
      Widget _buildColorGrid(BuildContext context) {
        List<Color> colors = [          Colors.red,          Colors.redAccent,          Colors.pink,          Colors.pinkAccent,          Colors.purple,          Colors.purpleAccent,          Colors.deepPurple,          Colors.deepPurpleAccent,          Colors.indigo,          Colors.indigoAccent,          Colors.blue,          Colors.blueAccent,          Colors.lightBlue,          Colors.lightBlueAccent,          Colors.cyan,          Colors.cyanAccent,          Colors.teal,          Colors.tealAccent,          Colors.green,          Colors.greenAccent,          Colors.lightGreen,          Colors.lightGreenAccent,          Colors.lime,          Colors.limeAccent,          Colors.yellow,          Colors.yellowAccent,          Colors.amber,          Colors.amberAccent,          Colors.orange,          Colors.orangeAccent,          Colors.deepOrange,          Colors.deepOrangeAccent,          Colors.brown,          Colors.grey,          Colors.blueGrey,          Colors.black,          Colors.white,        ];
    
    
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery
                 

Reminders Page
--------------

This screen will be launched when the user presses on a mode, this reminders page will be unique to that mode as it will have a colour banner the same colour that the mode has. The page will also show the reminders that are specific to the mode which was pressed. The code then will fetch all the reminders that are stored in the database with a foreign key the same as the mode's primary id. The reminders that are found within the mode are sorted in a list, each reminder has 2 interactable widgets as well as the ability to long press it. The check box allows users to check off the reminder, The delete button will delete the reminder by deleting the record within the database, and the long press will bring up details of the reminder, allowing the user to edit the details of the reminder. In the bottom right corner of the screen there will be an interactable widget with a "+" on it, this will take the users to a screen to add a new reminder.

*Retrieving data and Constructing reminder widgets*

When the user presses on the mode for the reminders they would like to access, a data stream will be sent out. :samp:`StreamBuilder` listens for a stream of data, once it receives it, it will have the :samp:`mode.id` for the mode. This queries the Firebase Database which returns all the reminders with that specific :samp:`mode.id`. It then builds the records from the database into objects, each reminder object contains: a title, completion status, and description. The reminder widgets are then built using :samp:`ListView.builder` as every reminder is retrieved a :samp:`ListTile` widget is created, Which has the title as well as interactable checkbox and delete buttons. Each reminder is placed in a list.

Below is the code for retrieving the data and creating the widgets:

.. code-block:: dart

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
                    if (reminder.title == null || reminder.title.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: ListTile(
                          title: Text("Error: Reminder has no title"),
                        ),
                      );
                    }
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
                          FirebaseFirestore.instance
                              .collection('reminders')
                              .doc(reminderId)
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReminderScreen(
                                        reminderId: documentSnapshot.id,
                                        title: documentSnapshot['title'],
                                        description:
                                            documentSnapshot['description'])),
                              );
                            } else {
                              print('Document does not exist');
                            }
                            ;
                          });
                        }, // navigate to reminder options to update current reminder
                      ),
                    );
                  });
            }));
  }



*Long press on reminder widget*

When a long press occurs on the reminder widget using the :samp:`onLongPress` property, triggering :samp:`_navigateToReminderOptionsPage` which makes the program fetch the specific record from the firebase database using :samp:`reminderId`. If the page exists it navigates to the correct screen using :samp:`ReminderScreen` passing the reminder's ID, title, and description as parameters to the screen. This allows the user to edit the reminder, bypassing the reminder button.

The code for the long press is:

.. code-block:: dart

    onLongPress: () {
      FirebaseFirestore.instance
          .collection('reminders')
          .doc(reminderId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReminderScreen(
                    reminderId: documentSnapshot.id,
                    title: documentSnapshot['title'],
                    description:
                        documentSnapshot['description'])),
          );
        } else {
          print('Document does not exist');
        }
        ;
      });
    }

*Check box and delete buttons on reminder Widgets*

When the Reminders are added to the screen, the edit and delete buttons are added. The checkbox allows to change the reminder to become completed when checked, this is using the checkboxe's :samp:`trailing` property. Changing the reminder to complete will put a line through the writing. The delete button is next to the checkbox and when triggered, deletes the reminder by deleting the reminder within the database.

below is the code for the checkbox and the delete button:

.. code-block:: dart

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
            reminderId);
      },
    )

*Add Reminder Widget*

The Add Reminder widget is located in the bottom right corner of the screen. When it is pressed it navigates the user to the "New Reminder" screen. This widget will appear the same to each user.

The code for the widget is below:

.. code-block:: dart

    floatingActionButton: FloatingActionButton(
      onPressed: (_navigateToReminderOptionsPage),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    )

The code for the whole screen is:

.. code-block:: dart

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
        Reminder newReminder = Reminder(
            title: 'New Reminder',
            completed: false,
            description: 'Description',
            dateTime: Timestamp.now());
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
                        if (reminder.title == null || reminder.title.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: ListTile(
                              title: Text("Error: Reminder has no title"),
                            ),
                          );
                        }
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
                              FirebaseFirestore.instance
                                  .collection('reminders')
                                  .doc(reminderId)
                                  .get()
                                  .then((DocumentSnapshot documentSnapshot) {
                                if (documentSnapshot.exists) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReminderScreen(
                                            reminderId: documentSnapshot.id,
                                            title: documentSnapshot['title'],
                                            description:
                                                documentSnapshot['description'])),
                                  );
                                } else {
                                  print('Document does not exist');
                                }
                                ;
                              });
                            }, // navigate to reminder options to update current reminder
                          ),
                        );
                      });
                }));
      }
    }

New Reminder
------------

Reminders Options Page
----------------------
When the user long presses on a specific reminder it will bring up this screen with the information that is held in the Firebase Database, which is inserted into the widgets. This allows the user to see the details within the reminder (as in the previous page you can only see the title), it also allows the user to edit all the details of the reminder. The list of widgets that can be edited is as follows: title, description, date & time, Location, priority of the reminder, Picture and Mode. The user will save the Reminder edits by pressing the save icon, the code will then do a validation check, and if it passes it will update the record within the database.

*Retrieving and inserting correct Reminder*

When the user long presses on a reminder, :samp:`_loadReminderOptions` is triggered and the :samp:`reminderId` is used in the :samp:`reminderScreen` class. This class uses the Primary Key of the Reminder (:samp:`reminderId`) into the database to retrieve the rest of the data for the reminder's record. This data is then used to populates the relevant fields within the screen.

The code for this is below:

.. code-block:: dart

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

More of the code:

.. code-block:: dart

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

*editing the reminders*
Users may edit many aspects of the reminders, through widgets. The description can be edited via a :samp:`TextField`. :Samp:`ListTile` widgets are used for the rest of the edits made to the reminders such at the Date & Time, Location, Priority, Take Picture and Mode. To see more information on the specific widgets see the "New Reminder" section.

Below is the code for the edit widgets:
Text description:

.. code-block:: dart

   TextField(
     controller: _description,
     maxLines: 5,
     decoration: InputDecoration(
       hintText: 'Notes',
       border: OutlineInputBorder(),
       labelText: widget.description,
     ),
   )

Date&Time Picker:

.. code-block:: dart

   ListTile(
     leading: Icon(Icons.date_range),
     title: Text('Date & Time'),
     trailing: Icon(Icons.arrow_forward_ios),
     onTap: _pickDateTime,
   )

Location Picker:

.. code-block:: dart

   ListTile(
     leading: Icon(Icons.location_on),
     title: Text('Location'),
     trailing: Icon(Icons.arrow_forward_ios),
     onTap: () async {
       // Handle location selection
       LocationPermission permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse) {
         Position position = await Geolocator.getCurrentPosition(
             desiredAccuracy: LocationAccuracy.high);
         // Do something with the obtained position
         print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
       } else {
         // Handle the case when location permission is not granted
         // You can show a dialog or request permission again
         print('Location permission not granted.');
       }
     },
   )

Priority Selection:

.. code-block:: dart

   ListTile(
     leading: Icon(Icons.priority_high),
     title: Text('Priority'),
     trailing: Icon(Icons.arrow_forward_ios),
     onTap: () {
       // Handle priority selection
       // You can show a dropdown or dialog for priority options
     },
   )

Image Picker:

.. code-block:: dart

   ListTile(
     leading: Icon(Icons.camera),
     title: Text('Take Picture'),
     trailing: Icon(Icons.arrow_forward_ios),
     onTap: _pickImage,
   )



*Savings updated Reminder*

Once the user has finished editing, the reminder and would like to save it, they simply press the "SAVE" button. The first check that is done is that the title field is not empty so it's a valid input. Once the button is pressed the methods: :samp:`_updateDescription` and :samp:`_updateDateTime ` which correspond with the Firebase Database update their respective sections of the records. The updated data is then reflected visually in the UI.

Below is the code for the save: 
.. code-block:: dart

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
       },
       color: Color.fromARGB(245, 176, 67, 154),
       elevation: 0,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.zero,
       ),
       textColor: Color.fromARGB(255, 0, 0, 0),
       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
       child: Text(
         'SAVE',
       ),
     ),
   )

Below is the whole code for this screen: 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReminderScreen extends StatefulWidget {
  final String reminderId;
  final String title;
  String description;

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
  final TextEditingController _date = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (widget.reminderId.isNotEmpty) {
      _loadReminderOptions(id: widget.reminderId);
    }
  }

  XFile? _imageFile;
  String? _imageUrl;
  DateTime? _dateTime;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Reference storageRef = _storage.ref().child('images/${image.name}');
      final UploadTask uploadTask = storageRef.putFile(File(image.path).absolute);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageFile = image;
        _imageUrl = downloadUrl;
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
        return {};
      }
    } catch (e) {
      print('Error loading reminder options: $e');
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
                SizedBox(height: 16),
                TextField(
                  controller: _description,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Notes',
                    border: OutlineInputBorder(),
                    labelText: widget.description,
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
                  leading: Icon(Icons.location_on),
                  title: Text('Location'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    LocationPermission permission =
                        await Geolocator.requestPermission();
                    if (permission == LocationPermission.always ||
                        permission == LocationPermission.whileInUse) {
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      print(
                          'Latitude: ${position.latitude}, Longitude: ${position.longitude}');
                    } else {
                      print('Location permission not granted.');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.priority_high),
                  title: Text('Priority'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Take Picture'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: _pickImage,
                ),
                _imageUrl != null
                    ? Image.network(
                        _imageUrl!,
                        height: 100,
                        width: 100,
                      )
                    : Container(),
                ListTile(
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
                  alignment: Alignment(0.0, 0.9),
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
                    },
                    color: Color.fromARGB(245, 176, 67, 154),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    textColor: Color.fromARGB(255, 0, 0, 0),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'SAVE',
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}


Creating recipes
----------------

To retrieve a list of random ingredients,
you can use the ``lumache.get_random_ingredients()`` function:

.. autofunction:: lumache.get_random_ingredients

The ``kind`` parameter should be either ``"meat"``, ``"fish"``,
or ``"veggies"``. Otherwise, :py:func:`lumache.get_random_ingredients`
will raise an exception.

.. autoexception:: lumache.InvalidKindError

For example:

>>> import lumache
>>> lumache.get_random_ingredients()
['shells', 'gorgonzola', 'parsley']

