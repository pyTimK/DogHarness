import 'package:bluetooth_app_test/firebase_options.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:bluetooth_app_test/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyStyles.dark700Swatch,
        fontFamily: 'Inter',
      ),
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
