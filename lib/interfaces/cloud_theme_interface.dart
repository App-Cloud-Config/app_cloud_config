import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

abstract class CloudThemeInterface {
  ColorScheme get darkTheme;
  ColorScheme get lightTheme;

  // setTheme({
  //   required ColorScheme colorScheme,
  //   required CloudThemeModes themeMode,
  // });

  Future<void> init({
    Map<String, dynamic>? config,
    FirebaseApp? app,
  });
}
