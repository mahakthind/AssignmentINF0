import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(const CoreFusionApp());
}

class CoreFusionApp extends StatelessWidget {
  const CoreFusionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoreFusion Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Dashboard(),
    );
  }
}
