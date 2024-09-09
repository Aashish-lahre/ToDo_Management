import 'package:flutter/material.dart';
import 'package:task_management/widgets/settings/app_settings.dart';
import 'package:task_management/widgets/settings/settings_container.dart';

import '../../widgets/settings/preference_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
      ),

      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
                PreferenceSettings(),
              AppSettings(),
              
            ],
          ),
        ),
      ),
    );
  }
}
