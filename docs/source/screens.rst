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

The widgets which are created within the mode widget will appear different to every user as they are customised to how the user has added them.  When each mode is clicked the app will navigate to the specific mode reminders. This is achieved by the app retrieving the mode settings from the database based on the user's preferences. The modes are sorted into this database with :samp:`mode.id` as the primary key, which is also used as a foreign key for reminders to associate them with a mode. The name of the mode is stored under :samp:`mode.description`. The rest of the columns within the database are associated with the appearance of the widget for the mode: :samp:`mode.color` for the colour and `mode.icon` for the icon. In the bottom right of the widget there is an edit button, which takes users to a page to edit the details of the mode. Next to the edit icon, there is a delete icon which will delete the mode by deleting the row in the database so it will no longer show up for the users. This widget is the most code-heavy and difficult to implement.


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

..code-block :: dart

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


Settings Screen
---------------
Once The user has clicked the settings icon the app will take the user to the settings page, which allows the appereance of the app. The user can change the size of the font and the background of the app When the user fir

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

