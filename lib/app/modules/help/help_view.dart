import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/main_layout.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Help',
      body: Center(
        child: Text(
          'Help Screen',
          style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
