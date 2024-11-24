// manage.dart
import 'package:flutter/material.dart';

class ManagePage extends StatelessWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Students")),
      body: Center(
        child: const Text("This is the Manage Students page."),
      ),
    );
  }
}
