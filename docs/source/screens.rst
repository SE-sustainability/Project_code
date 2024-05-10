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

This widget allows the user to choose an icon to represent the mode. This is represented by a grid in whihc the user can choose from predefined icons. The :samp:`_buildIconGrid` method arranges the icons into a grid for the user to choose from.

Below is the code for the icon widget:

.. code-block: dart

   IconButton(
    icon: Icon(_selectedIcon),
    onPressed: () {
     _pickIcon(context);
    },
    iconSize: 40
  ),

Below is the code that rearanages the icons into a grid:

.. code-block: dart

  Widget _buildIconGrid(BuildContext context) {
    List<IconData> icons = [
      Icons.home,
      Icons.work,
      Icons.beach_access,
    // List of icons in grid
    ];
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

The colour picker is programed very similary to the icon picker, only using colours instead of icons. The grid is built using the :samp:`_buildColorGrid`, when the user presses on the colour picker, the grid will appear. When the user presses on one of the colours, :samp:`_selectedColor` is triggered and the colour is updated.

Below is the code for the colour widget:

.. code-break:: dart

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

.. code-break:: dart

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







*Save Widget*






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

