import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/main_layout.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Settings',
      body: Center(
        child: Text(
          'Settings Screen',
          style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
