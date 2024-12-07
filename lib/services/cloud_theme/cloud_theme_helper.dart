import 'package:app_cloud_config/enums/cloud_theme_modes.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class CloudAppConfigHelper {
  final FirebaseRemoteConfig _firebaseRemoteConfig;

  CloudAppConfigHelper({required FirebaseRemoteConfig firebaseRemoteConfig})
      : _firebaseRemoteConfig = firebaseRemoteConfig;

  // Helper method to fetch the theme from Remote Config and build ColorScheme
  ColorScheme getTheme(CloudThemeModes themeMode) {
    Map<String, String> colors = getColorFromRemoteConfig(themeMode);

    // Create a ColorScheme using the retrieved color values
    return ColorScheme(
      brightness: themeMode == CloudThemeModes.dark
          ? Brightness.dark
          : Brightness.light,
      primary: hexToColor(colors['${themeMode.name}_primary']!),
      secondary: hexToColor(colors['${themeMode.name}_secondary']!),
      surface: hexToColor(colors['${themeMode.name}_surface']!),
      error: hexToColor(colors['${themeMode.name}_error']!),
      onPrimary: hexToColor(colors['${themeMode.name}_onPrimary']!),
      onSecondary: hexToColor(colors['${themeMode.name}_onSecondary']!),
      onSurface: hexToColor(colors['${themeMode.name}_onSurface']!),
      onError: hexToColor(colors['${themeMode.name}_onError']!),
    );
  }

  // Helper method to fetch colors from Remote Config based on the theme mode
  Map<String, String> getColorFromRemoteConfig(CloudThemeModes themeMode) {
    Map<String, String> colors = {};

    // Fetch the color values from Firebase Remote Config
    colors['${themeMode.name}_primary'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_primary');
    colors['${themeMode.name}_secondary'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_secondary');
    colors['${themeMode.name}_background'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_background');
    colors['${themeMode.name}_surface'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_surface');
    colors['${themeMode.name}_error'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_error');
    colors['${themeMode.name}_onPrimary'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_onPrimary');
    colors['${themeMode.name}_onSecondary'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_onSecondary');
    colors['${themeMode.name}_onBackground'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_onBackground');
    colors['${themeMode.name}_onSurface'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_onSurface');
    colors['${themeMode.name}_onError'] =
        _firebaseRemoteConfig.getString('${themeMode.name}_onError');

    return colors;
  }

  Color hexToColor(String hexCode) {
    if (hexCode != '' && hexCode.isNotEmpty) {
      // Remove '#' if it exists
      hexCode = hexCode.replaceAll('#', '');

      // If the hex code is 6 characters long (RGB), add 'FF' for full opacity
      if (hexCode.length == 6) {
        hexCode = 'FF$hexCode'; // Adding full opacity
      }

      return Color(int.parse('0x$hexCode'));
    }
    return Colors.red;
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
