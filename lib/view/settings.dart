import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';

  const Settings({super.key, required this.isActive});

  final bool isActive;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
