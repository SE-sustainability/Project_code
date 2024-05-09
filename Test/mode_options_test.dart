import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:coursework_project/screens/Backend/modes.dart'; // Import the Mode class

void main() {
  group('Mode', () {
    const icon = Icons.alarm;
    const color = Colors.blue;

    test('creates a Mode object', () {
      final mode = Mode(
        id: '1', // Provide a unique identifier for testing
        description: 'Test Mode',
        icon: icon,
        color: color,
      );

      expect(mode.description, 'Test Mode');
      expect(mode.icon, icon);
      expect(mode.color, color);
    });

    test('converts a Mode object to a Map', () {
      final mode = Mode(
        id: '1', // Provide a unique identifier for testing
        description: 'Test Mode',
        icon: icon,
        color: color,
      );
      final map = mode.toJson();

      expect(map, {
        'id': '1',
        'description': 'Test Mode',
        'icon': '${icon.codePoint}',
        'color': '${color.value}',
      });
    });

    test('creates a Mode object from a Map', () {
      final map = {
        'id': '1', // Provide a unique identifier for testing
        'description': 'Test Mode',
        'icon': '${icon.codePoint}',
        'color': '${color.value}',
      };
      final mode = Mode.fromJson(map);

      expect(mode.description, 'Test Mode');
      expect(mode.icon, icon);
      expect(mode.color, color);
    });

    test('copies a Mode object', () {
      final mode = Mode(
        id: '1', // Provide a unique identifier for testing
        description: 'Test Mode',
        icon: icon,
        color: color,
      );
      final copiedMode = mode.copyWith();

      expect(copiedMode.description, 'Test Mode');
      expect(copiedMode.icon, icon);
      expect(copiedMode.color, color);
    });
  });
}