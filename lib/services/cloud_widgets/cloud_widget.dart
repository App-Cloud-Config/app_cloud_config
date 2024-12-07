import 'dart:convert';
import 'dart:developer';

import 'package:app_cloud_config/enums/cloud_widgets.dart';
import 'package:app_cloud_config/services/cloud_theme/cloud_theme.dart';
import 'package:flutter/material.dart';

class CloudWidget<T> extends StatelessWidget {
  final CloudWidgets widgetType;
  final String widgetId;
  final Widget Function(T config) builder;

  const CloudWidget({
    super.key,
    required this.widgetType,
    required this.widgetId,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch data from Firebase Remote Config
    final config = getWidgetConfig();
    return builder(config as T);
  }

  Map<String, dynamic> getWidgetConfig() {
    // Fetch the configuration from Firebase Remote Config
    final remoteConfig = CloudAppConfig.instance.firebaseRemoteConfig;

    // Get the value for the widgetId (this should be your parameter name)
    String jsonConfig = remoteConfig.getString(widgetId);

    // Parse the JSON string into a Map
    final Map<String, dynamic> configMap = json.decode(jsonConfig);
    log(configMap.toString());
    // Based on the widget type, return the appropriate config data
    return configMap;
  }
}
