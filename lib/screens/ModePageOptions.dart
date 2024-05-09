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
    List<IconData> icons = [
      Icons.home,
      Icons.work,
      Icons.beach_access,
      Icons.directions_car,
      Icons.accessibility_new,
      Icons.menu_book,
      Icons.school,
      Icons.lightbulb,
      Icons.fastfood_outlined,
      Icons.coffee,
      Icons.school,
      Icons.lightbulb,
      Icons.attach_money,
      Icons.brush,
      Icons.camera,
      Icons.directions_bike,
      Icons.directions_bus,
      Icons.directions_boat,
      Icons.directions_railway,
      Icons.directions_run,
      Icons.directions_walk,
      Icons.event,
      Icons.favorite,
      Icons.home_work,
      Icons.kitchen,
      Icons.local_cafe,
      Icons.local_gas_station,
      Icons.local_hospital,
      Icons.local_pharmacy,
      Icons.local_pizza,
      Icons.movie,
      Icons.music_note,
      Icons.shopping_basket,
      Icons.shopping_cart,
      Icons.sports_soccer,
      Icons.star,
      Icons.tag_faces,
      Icons.terrain,
      Icons.train,
      Icons.work,
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
    List<Color> colors = [
      Colors.red,
      Colors.redAccent,
      Colors.pink,
      Colors.pinkAccent,
      Colors.purple,
      Colors.purpleAccent,
      Colors.deepPurple,
      Colors.deepPurpleAccent,
      Colors.indigo,
      Colors.indigoAccent,
      Colors.blue,
      Colors.blueAccent,
      Colors.lightBlue,
      Colors.lightBlueAccent,
      Colors.cyan,
      Colors.cyanAccent,
      Colors.teal,
      Colors.tealAccent,
      Colors.green,
      Colors.greenAccent,
      Colors.lightGreen,
      Colors.lightGreenAccent,
      Colors.lime,
      Colors.limeAccent,
      Colors.yellow,
      Colors.yellowAccent,
      Colors.amber,
      Colors.amberAccent,
      Colors.orange,
      Colors.orangeAccent,
      Colors.deepOrange,
      Colors.deepOrangeAccent,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
      Colors.white,
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
  }}



