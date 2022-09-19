import 'package:bluetooth_app_test/change_notifiers/bluetooth_data.dart';
import 'package:bluetooth_app_test/change_notifiers/account_data.dart';
import 'package:bluetooth_app_test/change_notifiers/registration_data.dart';
import 'package:bluetooth_app_test/home.dart';
import 'package:bluetooth_app_test/main.dart';
import 'package:bluetooth_app_test/pages/home.dart';
import 'package:bluetooth_app_test/pages/login.dart';
import 'package:bluetooth_app_test/pages/register.dart';
import 'package:bluetooth_app_test/pages/verify_email.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothState bluetoothState = BluetoothState.unknown;
  User? user;

  //init
  @override
  void initState() {
    super.initState();
    flutterBlue.setLogLevel(LogLevel.debug);
    flutterBlue.state.listen((state) {
      setState(() {
        bluetoothState = state;
      });
    });

    FirebaseAuth.instance.userChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (parentContext) => BluetoothData(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: MyStyles.backgroundGradient,
            ),
            child: ListView(
              // shrinkWrap: true,
              // physics: const BouncingScrollPhysics(),
              children: [
                user == null
                    ? const LogInPage()
                    : Provider.value(
                        value: user!,
                        child: !user!.emailVerified
                            ? const VerifyEmailPage()
                            : ChangeNotifierProvider(
                                create: (context) => RegistrationData(user!.uid),
                                builder: (context, child) {
                                  var registrationData = Provider.of<RegistrationData>(context);
                                  if (registrationData.isRegistered == null) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  if (!registrationData.isRegistered!) {
                                    return const RegisterPage();
                                  }

                                  return MultiProvider(providers: [
                                    ChangeNotifierProvider(create: (context) => AccountData(user!.uid)),
                                  ], builder: (context, child) => const HomePage());
                                },
                              ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
