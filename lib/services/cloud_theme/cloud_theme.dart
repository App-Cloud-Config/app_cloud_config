import 'package:app_cloud_config/enums/cloud_theme_modes.dart';
import 'package:app_cloud_config/interfaces/cloud_theme_interface.dart';
import 'package:app_cloud_config/services/cloud_theme/cloud_theme_helper.dart';
import 'package:app_cloud_config/services/cloud_theme/cloud_theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class CloudAppConfig implements CloudThemeInterface {
  // Static variable to hold the singleton instance
  static CloudAppConfig? _instance;

  // Private constructor to prevent external instantiation
  CloudAppConfig._();

  // Static method to get the singleton instance
  static CloudAppConfig get instance {
    _instance ??=
        CloudAppConfig._(); // If _instance is null, create a new instance
    return _instance!;
  }

  late final FirebaseRemoteConfig firebaseRemoteConfig;

  final CloudAppConfigManager _cloudThemeManager =
      CloudAppConfigManager.instance;
  @override
  ColorScheme get darkTheme {
    final CloudAppConfigHelper cloudThemeHelper =
        CloudAppConfigHelper(firebaseRemoteConfig: firebaseRemoteConfig);
    return cloudThemeHelper.getTheme(CloudThemeModes.light);
  }

  @override
  ColorScheme get lightTheme {
    final CloudAppConfigHelper cloudThemeHelper =
        CloudAppConfigHelper(firebaseRemoteConfig: firebaseRemoteConfig);
    return cloudThemeHelper.getTheme(CloudThemeModes.light);
  }

  @override
  Future<void> init({Map<String, dynamic>? config, FirebaseApp? app}) async {
    if (app != null && config != null) {
      throw ArgumentError('You cannot provide both app and serviceFilePath.');
    }
    if (app != null) {
      // If the app is provided, initialize Firebase with the app instance.
      try {
        firebaseRemoteConfig = FirebaseRemoteConfig.instanceFor(app: app);
      } catch (e) {
        throw Exception(
            'Failed to initialize Firebase Remote Config with the provided app: $e');
      }
    } else if (config != null) {
      // If a service account file path is provided, read and initialize Firebase
      try {
        FirebaseApp app =
            await _cloudThemeManager.getFirebaseAppFromFile(config);

        // Now initialize Firebase Remote Config using the custom app
        firebaseRemoteConfig = FirebaseRemoteConfig.instanceFor(app: app);

        await firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ));
        // await setTheme(
        //     colorScheme: const ColorScheme.dark(),
        //     themeMode: CloudThemeModes.dark);
        // await setTheme(
        //   colorScheme: const ColorScheme.light(),
        //   themeMode: CloudThemeModes.light,
        // );
        // Fetch and activate the remote config

        await firebaseRemoteConfig.fetchAndActivate();
      } catch (e) {
        throw Exception(
            'Failed to initialize Firebase using the service account file: $e');
      }
    } else {
      throw ArgumentError(
          'You must provide either a serviceFilePath or an app instance.');
    }
  }

  // @override
  // Future<void> setTheme(
  //     {required ColorScheme colorScheme,
  //     required CloudThemeModes themeMode}) async {
  //   // Create a map to hold the key-value pairs for the remote config
  //   Map<String, String> configValues = {};

  //   // Define a helper function to handle the color scheme keys and values
  //   void addColorToConfig(String colorName, Color color) {
  //     final CloudThemeHelper cloudThemeHelper =
  //         CloudThemeHelper(firebaseRemoteConfig: _firebaseRemoteConfig);
  //     String colorHex = cloudThemeHelper.colorToHex(color);
  //     log('${themeMode.name}_$colorName');
  //     String key = '${themeMode.name}_$colorName';
  //     configValues[key] = colorHex;
  //   }

  //   // Loop through all the colors in the ColorScheme
  //   addColorToConfig('primary', colorScheme.primary);
  //   addColorToConfig('secondary', colorScheme.secondary);
  //   addColorToConfig('background', colorScheme.surface);
  //   addColorToConfig('surface', colorScheme.surface);
  //   addColorToConfig('error', colorScheme.error);
  //   addColorToConfig('onPrimary', colorScheme.onPrimary);
  //   addColorToConfig('onSecondary', colorScheme.onSecondary);
  //   addColorToConfig('onBackground', colorScheme.onSurface);
  //   addColorToConfig('onSurface', colorScheme.onSurface);
  //   addColorToConfig('onError', colorScheme.onError);

  //   try {
  //     // Update the Firebase Remote Config with the new color values
  //     await _firebaseRemoteConfig.setDefaults(configValues);
  //     print(
  //         'Theme data has been successfully written to Firebase Remote Config!');
  //   } catch (e) {
  //     print('Error while setting theme: $e');
  //   }
  // }
}
