import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/main_layout.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Profile',
      body: Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
