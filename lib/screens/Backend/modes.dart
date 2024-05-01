// import 'package:flutter/material.dart';

class Mode {
  final int id;
  final String name;
  final String icon;
  final String colour;

  Mode(
      {required this.id,
      required this.name,
      required this.icon,
      required this.colour});

  Mode.fromJson(Map<String, Object?> json)
      : this(
            id: json['id']! as int,
            name: json['name']! as String,
            icon: json['icon']! as String,
            colour: json['colour']! as String);
}
