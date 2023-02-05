import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/firebase_options.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/pages/pushedPages/about.dart';
import 'package:bluetooth_app_test/pages/pushedPages/addDog.dart';
import 'package:bluetooth_app_test/pages/pushedPages/dogProfile.dart';
import 'package:bluetooth_app_test/pages/pushedPages/gps_data.dart';
import 'package:bluetooth_app_test/pages/pushedPages/ownerProfile.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:bluetooth_app_test/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // _try() async {
  //   const queryParameters = {
  //     'dogId': "AQqNXymsQJlMCce9E48B",
  //   };

  //   final uri = Uri.https('late-pond-5613.fly.dev', '/changeDogId', queryParameters);
  //   final response = await http.post(uri);
  //   logger.wtf(response.body);
  // }

  @override
  Widget build(BuildContext context) {
    // _try();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyStyles.dark700Swatch,
        fontFamily: 'Inter',
      ),
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        RouteNames.addDog: (context) => const AddDogPage(),
        RouteNames.dogProfile: (context) => const DogProfilePage(),
        RouteNames.ownerProfile: (context) => const OwnerProfilePage(),
        RouteNames.about: (context) => const AboutPage(),
        RouteNames.gpsData: (context) => const GPSData(),
      },
    );
  }
}
