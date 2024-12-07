# app_cloud_config

`app_cloud_config` is a cloud-based solution designed to enable dynamic theme changes for your Flutter app, even after it has been deployed to production. With `cloude_theme`, you can seamlessly manage and switch your app’s theme from a web interface, providing a flexible and powerful way to adjust your app’s look and feel without needing to release an update.

## Features
- Easily change the app’s theme from a web-based application.
- Simple initialization without wrapping your app with additional widgets.
- Supports real-time theme updates.
- Adjustable widgets that can be modified and updated from the web app.

## Installation
To use `app_cloud_config`, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  app_cloud_config: ^1.0.0
```

Then, run the following command in your terminal:

```bash
flutter pub get
```

## Configuration
To initialize `app_cloud_config` and set up your app, follow these steps:

1. Import `app_cloud_config` and initialize it in your `main` method:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:app_cloud_config/cloud_theme.dart';

   void main() async {
     // For Firebase JS SDK v7.20.0 and later, measurementId is optional
     const firebaseConfig = {
       "apiKey": "AIzaSyD-4RAvY5QSRpRCuruQiiJLuEwqnGhm-nE",
       "authDomain": "app-cloud-85563.firebaseapp.com",
       "projectId": "app-cloud-85563",
       "storageBucket": "app-cloud-85563.firebasestorage.app",
       "messagingSenderId": "168385431131",
       "appId": "1:168385431131:web:eafe82fcf1f23de930a17e",
       "measurementId": "G-KBXXSS67YR"
     };
     await CloudTheme.instance.init(config: firebaseConfig);
     runApp(const App());
   }
   ```

2. **Use the cloud-based theme**:
   In your `MaterialApp`, set the `theme` and `darkTheme` properties to use `CloudTheme`'s themes:

   ```dart
   MaterialApp(
     title: 'Cloude Theme Demo',
     theme: ThemeData(colorScheme: CloudTheme.instance.lightTheme),
     darkTheme: ThemeData(colorScheme: CloudTheme.instance.darkTheme),
     home: HomePage(),
   );
   ```

3. **Adjustable widgets**:
   You can create customizable widgets that are configurable from the web app:

   - **SizedBox**:
     ```dart
     CloudWidget<Map<String, dynamic>>(
       widgetType: CloudWidgets.SizedBox,
       widgetId: 'sizedbox_m1q4p',
       builder: (config) {
         return SizedBox(
           width: double.parse(config['width']),
           height: double.parse(config['height']),
           child: Container(
             color: Colors.blue,
           ),
         );
       },
     );
     ```

   - **Text**:
     ```dart
     CloudWidget<Map<String, dynamic>>(
       widgetType: CloudWidgets.Text,
       widgetId: 'text_BeJWi',
       builder: (config) {
         return Text(
           config['text']!,
           style: TextStyle(
             color: Colors.black,
             fontSize: double.parse(config['fontSize']),
           ),
         );
       },
     );
     ```
