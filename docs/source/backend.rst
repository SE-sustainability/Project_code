Backend
========


Modes
-----
This file creates a :smap`mode` class which is used throughout the app, this uses methods to create instances from JSON ( a file format), copying instances, and converting instances to JSON. It is designed to to work with modes within a Flutter application, especially when working with JSON data.
It firstly imports necessary packages from the Flutter Framework. The import of :samp:`Matrial.dart` provides UI components and :samp:`dart:convert` which allows JSON data to work within Flutter. 
The :samp:`mode` class represents a mode within the application (the modes sort the reminders within the app). The constructor of the class makes sure that each instance of a mode has the following properties (all of which are required): :samp:`id`, :samp:`description`, :samp:`icon` and :samp:`color`. 
The JSON Factory constructor allows the creation of a :samp:`mode` within an instance of a JSON map. 
The :samp:`copyWith` Method extracts :samp:`id`, :samp:`description`, :samp:`icon` and :samp:`color` from the JSON map and initialised it with the :samp:`mode` object. 
The :samp:`toJSON` method coverts a :samp:`Mode` instance into a JSON map, this will save :samp:`Mode` objects to a file which can be sent over a network.

The code of the modes file is below:

.. code-block:: dart

    import 'package:flutter/material.dart';
    class Mode {
      final String id;
      final String description;
      final IconData icon;
      final Color color;

      Mode({required this.id,required this.description, required this.icon, required this.color});

      Mode.fromJson(Map<String, dynamic> json)
          : id = json['id'] as String,
            description = json['description'] as String,
            icon = IconData(int.parse(json['icon'] as String), fontFamily: 'MaterialIcons'), // Convert icon code to IconData
            color = Color(int.parse(json['color'] as String)
            );

      Mode copyWith({
        String? id,
        String? description,
        IconData? icon,
        Color? color,
      }) {
        return Mode(
          id: id ?? this.id,
          description: description ?? this.description,
          icon: icon?? this.icon,
          color: color?? this.color,

        );
      }
      Map<String, dynamic> toJson() {
        return {
          'id' : id,
          'description' : description,
          'icon' : '${icon.codePoint}',
          'color' : '${color.value}',
        };
      }
    }


Reminder
--------





Settings
--------
