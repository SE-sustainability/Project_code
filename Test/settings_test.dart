import 'package:flutter/material.dart';
import 'package:coursework_project/screens/Backend/settings.dart';
import 'package:test/test.dart';

void main() {
  group('CreateSettingsScreen', () {
    late CreateSettingsScreen createSettingsScreen;

    setUp(() {
      createSettingsScreen = CreateSettingsScreen();
    });

    test('getBackgroundColor returns a Color object', () {
      expect(createSettingsScreen.getBackgroundColor('white'), isA<Color>());
      expect(createSettingsScreen.getBackgroundColor('grey'), isA<Color>());
      expect(createSettingsScreen.getBackgroundColor('green'), isA<Color>());
      expect(createSettingsScreen.getBackgroundColor('blue'), isA<Color>());
      expect(createSettingsScreen.getBackgroundColor('yellow'), isA<Color>());
    });

    test('getTextColor returns a Color object', () {
      expect(createSettingsScreen.getTextColor('white'), isA<Color>());
      expect(createSettingsScreen.getTextColor('grey'), isA<Color>());
      expect(createSettingsScreen.getTextColor('green'), isA<Color>());
      expect(createSettingsScreen.getTextColor('blue'), isA<Color>());
      expect(createSettingsScreen.getTextColor('yellow'), isA<Color>());
    });

    test('getAppBarColor returns a Color object', () {
      expect(createSettingsScreen.getAppBarColor('white'), isA<Color>());
      expect(createSettingsScreen.getAppBarColor('grey'), isA<Color>());
      expect(createSettingsScreen.getAppBarColor('green'), isA<Color>());
      expect(createSettingsScreen.getAppBarColor('blue'), isA<Color>());
      expect(createSettingsScreen.getAppBarColor('yellow'), isA<Color>());
    });

    test('getDropdownTextColor returns a Color object', () {
      expect(createSettingsScreen.getDropdownTextColor('white'), isA<Color>());
      expect(createSettingsScreen.getDropdownTextColor('grey'), isA<Color>());
      expect(createSettingsScreen.getDropdownTextColor('green'), isA<Color>());
      expect(createSettingsScreen.getDropdownTextColor('blue'), isA<Color>());
      expect(createSettingsScreen.getDropdownTextColor('yellow'), isA<Color>());
    });
  });
}

class CreateSettingsScreen {
  Color getBackgroundColor(String color) {
    switch (color) {
      case 'white':
        return Colors.white;
      case 'grey':
        return Colors.black87;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  Color getTextColor(String color) {
    return Colors.white;
  }

  Color getAppBarColor(String color) {
    switch (color) {
      case 'white':
        return Colors.blue;
      case 'grey':
        return Colors.white12;
      case 'green':
        return Colors.blue;
      case 'blue':
        return Colors.black12;
      case 'yellow':
        return Colors.white12;
      default:
        return Colors.blue;
    }
  }

  Color getDropdownTextColor(String color) {
    return Colors.black;
  }
}