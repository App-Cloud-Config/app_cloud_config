import 'package:app_cloud_config/enums/cloud_theme_modes.dart';
import 'package:app_cloud_config/interfaces/cloud_theme_interface.dart';
import 'package:app_cloud_config/services/cloud_theme/cloud_theme_helper.dart';
import 'package:app_cloud_config/services/cloud_theme/cloud_theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

/// A singleton class responsible for managing cloud configuration related to themes and Firebase Remote Config.
class CloudAppConfig implements CloudThemeInterface {
  // Singleton instance of CloudAppConfig.
  static CloudAppConfig? _instance;

  // Private constructor for the singleton pattern.
  CloudAppConfig._();

  /// Returns the singleton instance of CloudAppConfig.
  static CloudAppConfig get instance {
    _instance ??= CloudAppConfig._();
    return _instance!;
  }

  // Instance of FirebaseRemoteConfig for fetching remote configuration.
  late final FirebaseRemoteConfig firebaseRemoteConfig;

  // Manager responsible for handling cloud theme configurations.
  final CloudAppConfigManager _cloudThemeManager =
      CloudAppConfigManager.instance;

  /// Retrieves the dark theme configuration from the remote service.
  ///
  /// Returns a [ColorScheme] representing the dark theme.
  @override
  ColorScheme get darkTheme {
    final CloudAppConfigHelper cloudThemeHelper =
        CloudAppConfigHelper(firebaseRemoteConfig: firebaseRemoteConfig);
    return cloudThemeHelper.getTheme(CloudThemeModes.dark);
  }

  /// Retrieves the light theme configuration from the remote service.
  ///
  /// Returns a [ColorScheme] representing the light theme.
  @override
  ColorScheme get lightTheme {
    final CloudAppConfigHelper cloudThemeHelper =
        CloudAppConfigHelper(firebaseRemoteConfig: firebaseRemoteConfig);
    return cloudThemeHelper.getTheme(CloudThemeModes.light);
  }

  /// Initializes the cloud app configuration by setting up Firebase Remote Config.
  ///
  /// You must provide either a [FirebaseApp] instance or a [config] map with the service account path.
  /// If [app] is provided, it initializes Firebase using that instance.
  /// If [config] is provided, it initializes Firebase using the service file path.
  ///
  /// Throws an [ArgumentError] if both [app] and [config] are provided.
  /// Throws an [Exception] if initialization fails.
  @override
  Future<void> init({Map<String, dynamic>? config, FirebaseApp? app}) async {
    if (app != null && config != null) {
      throw ArgumentError('You cannot provide both app and serviceFilePath.');
    }
    if (app != null) {
      try {
        // Initializes FirebaseRemoteConfig with the provided FirebaseApp.
        firebaseRemoteConfig = FirebaseRemoteConfig.instanceFor(app: app);
      } catch (e) {
        throw Exception(
            'Failed to initialize Firebase Remote Config with the provided app: $e');
      }
    } else if (config != null) {
      try {
        // Retrieves the Firebase app instance from the service file and initializes RemoteConfig.
        FirebaseApp app =
            await _cloudThemeManager.getFirebaseAppFromFile(config);

        firebaseRemoteConfig = FirebaseRemoteConfig.instanceFor(app: app);

        // Sets configuration settings for RemoteConfig.
        await firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ));

        // Fetches and activates the remote configuration.
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
}
