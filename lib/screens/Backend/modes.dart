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
