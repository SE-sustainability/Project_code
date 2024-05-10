Backend
========
This page documents the 3 files which are stored in the file called "backend"

Modes
-----
This file creates a :smap`mode` class which is used throughout the app, this uses methods to create instances from JSON ( a file format), copying instances, and converting instances to JSON. It is designed to to work with modes within a Flutter application, especially when working with JSON data.

It firstly imports necessary packages from the Flutter Framework. The import of :samp:`Matrial.dart` provides UI components and :samp:`dart:convert` which allows JSON data to work within Flutter. 

The :samp:`mode` class represents a mode within the application (the modes sort the reminders within the app). The constructor of the class makes sure that each instance of a mode has the following properties (all of which are required): :samp:`id`, :samp:`description`, :samp:`icon` and :samp:`color`. 

There is one constructor within the :samp:`mode` class. The JSON Factory constructor allows the creation of a :samp:`mode` within an instance of a JSON map.

There are 2 methods within the :samp:`mode` class. The :samp:`copyWith` Method extracts :samp:`id`, :samp:`description`, :samp:`icon` and :samp:`color` from the JSON map and initialised it with the :samp:`mode` object. The :samp:`toJSON` method coverts a :samp:`Mode` instance into a JSON map, this will save :samp:`Mode` objects to a file which can be sent over a network.

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
This file creates a class named :samp:`Reminder` which defines reminder data and provides methods to create instances from JSON (copying and converting instances to JSON). This class also interacts with the Firebase Database.

The file firstly imports :samp:`cloud_firestore.dart` which allows the file to interact with the Firebase cloud Firestore.

The class that this file defines represents a reminder within the application, containing the properties and methods related to reminders. The properties that the reminders have are: :samp:`title`(title of the reminder), :samp:`completed` (boolean value to see if reminder has been completed), :samp:`description` (description of the reminder) and :samp:`dateTime` (date and time of the reminder - uses :samp:`Timestamp` type from Firestore).

There are 2 Constructors within the :samp:`Reminder` class. The first Constructor initialises the :samp:`Reminder` properties when creating a new instance of :samp:`Reminder`. The :samp:`fromJson Factory` constructor allows the creation of a :samp:`Reminder` instance from a JSON map. It takes :samp:`Map<String, Object?> json` as an input where it extracts the properties to create a new :samp:`Reminder` object. This JSON map is expected to contain all the keys which corresponds to the properties of the :samp:`Reminder` class.

There are 2 methods within the :samp:`Reminder` class. The :samp:`copyWith` method creates a copy of the current :samp:`Reminder` instance with some or all of it's attributes overridden. This allows the updating of specific attributes of a :samp:`Reminder` instance without modifying the original instance. The :samp:`toJson` Method converts an instance of :samp:`Reminder`. It returns a map containing the properties of the :samp:`Reminder` object which can be stored in Firestore.

The code for the file is below:

.. code-block:: dart

    import 'package:cloud_firestore/cloud_firestore.dart';

    class Reminder {
      final String title;
      final bool completed;
      final String description;
      final Timestamp dateTime;

      Reminder({
        required this.title,
        required this.completed,
        required this.description,
        required this.dateTime,
      });

      Reminder.fromJson(Map<String, Object?> json)
          : this(
                title: json['title']! as String,
                completed: json['completed']! as bool,
                description: json['description'] as String,
                dateTime: json['dateTime'] as Timestamp);

      Reminder copyWith({
        String? title,
        bool? completed,
        String? description,
        Timestamp? dateTime,
      }) {
        return Reminder(
            title: title ?? this.title,
            completed: completed ?? this.completed,
            description: description ?? this.description,
            dateTime: dateTime ?? this.dateTime);
      }

      Map<String, Object?> toJson() {
        return {
          'title': title,
          'completed': completed,
          'description': description,
          'dateTime': dateTime
        };
      }
    }


Settings
--------

This file creates an :samp:`AppSettings` class which contains the application settings and provides methods to create instances from JSON and copy and convert instances to JSON. It's used to manage application configuration and user preferences.

The properties of :samp:`AppSettings` are :samp:`appBarColour`, :samp:`colour`, :samp:`fontSize` and :samp:`textColour`. These properties are used within the settings screen (to change the values) and the whole app in the background. All properties are required in the class when creating a new instance.

There are 2 constructors within the class. The first constructor of  the :samp:`AppSettings` class which initialises the properties when a new instance is created. The :samp:`fromJSON` constructor allows the creation of an :samp:`AppSettings` instance from a JSON map. It takes :samp:`Map<String, dynamic> json` (a JSON map) as an imput and extracts values to create a new  :samp:`AppSettings` object. To do this it assumes that the keys within the JSON file correspond to the properties of the :samp:`AppSettings`. 

There are 2 Methods within this file. The :samp:`copyWith` method creates a copy of the current :samp:`AppSettings` instance with some of all of its attributes changed. This allows the user to update specific attributes without modifying the original instance. The :samp:`toJsom` method converts an :samp:`AppSettings` instance into a JSON map. The method returns a map containing  the properties of the :samp:`AppSettings` which can be stored easily.

Below is the code in this file:

.. code-block:: dart

    class AppSettings {
      final String appBarColour;
      final String colour;
      final int fontSize;
      final String textColour;

      AppSettings({
        required this.appBarColour,
        required this.colour,
        required this.fontSize,
        required this.textColour,
      });

      AppSettings.fromJson(Map<String, dynamic> json)
          : appBarColour = json['appBarColour']! as String,
            colour = json['colour']! as String,
            fontSize = json['font_Size']! as int,
            textColour = json['textColour']! as String;

      AppSettings copyWith({
        String? appBarColour,
        String? colour,
        int? fontSize,
        String? textColour,
      }) {
        return AppSettings(
          appBarColour: appBarColour ?? this.appBarColour,
          colour: colour ?? this.colour,
          fontSize: fontSize ?? this.fontSize,
          textColour: textColour  ?? this.textColour,
        );
      }

      Map<String, dynamic> toJson(){
        return {
          'appBarColour' : appBarColour,
          'colour' : colour,
          'font_Size' : fontSize,
          'textColour' : textColour,
        };
      }
    }


