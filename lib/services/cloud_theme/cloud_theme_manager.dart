import 'package:firebase_core/firebase_core.dart';

class CloudAppConfigManager {
  // Static variable to hold the singleton instance
  static CloudAppConfigManager? _instance;

  // Private constructor to prevent external instantiation
  CloudAppConfigManager._();

  // Static method to get the singleton instance
  static CloudAppConfigManager get instance {
    _instance ??= CloudAppConfigManager
        ._(); // If _instance is null, create a new instance
    return _instance!;
  }

  /// Get firebase app object from service file path.
  Future<FirebaseApp> getFirebaseAppFromFile(
      Map<String, dynamic> config) async {
    // // Read the service account file (assuming it's a JSON file)
    // Uint8List fileBytes = await File(filePath).readAsBytes();
    // log(filePath.toString());
    // // Parse the JSON content
    // String content = String.fromCharCodes(fileBytes);
    // Map<String, dynamic> config = jsonDecode(content);
    // log(filePath.toString());
    // // Extract Firebase options
    FirebaseOptions options = FirebaseOptions(
      apiKey: config['apiKey'],
      appId: config['appId'],
      messagingSenderId: config['messagingSenderId'],
      projectId: config['projectId'],
      storageBucket: config['storageBucket'],
    ); // Initialize Firebase with the custom configuration
    return await Firebase.initializeApp(
      options: options,
    );
  }
}
