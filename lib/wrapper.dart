import 'package:bluetooth_app_test/change_notifiers/bluetooth_data.dart';
import 'package:bluetooth_app_test/pages/error.dart';
import 'package:bluetooth_app_test/pages/mainPages/home.dart';
import 'package:bluetooth_app_test/pages/loading.dart';
import 'package:bluetooth_app_test/pages/login.dart';
import 'package:bluetooth_app_test/pages/mainPages/mainPagesWrapper.dart';
import 'package:bluetooth_app_test/pages/register.dart';
import 'package:bluetooth_app_test/pages/verify_email.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart' as old_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  WrapperState createState() => WrapperState();
}

class WrapperState extends ConsumerState<Wrapper> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothState bluetoothState = BluetoothState.unknown;

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
  }

  @override
  Widget build(BuildContext context) {
    return old_provider.ChangeNotifierProvider(
      create: (parentContext) => BluetoothData(),
      child: const _VerifyUser(),
    );
  }
}

class _VerifyUser extends ConsumerWidget {
  const _VerifyUser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<User?> user = ref.watch(userProvider);
    return user.when(
      loading: () => const LoadingPage(),
      error: (error, stackTrace) => ErrorPage(error),
      data: (user) {
        if (user == null) {
          return const LogInPage();
        }
        if (!user.emailVerified) {
          return const VerifyEmailPage();
        }
        return const _VerifyUserRegistration();
      },
    );
  }
}

class _VerifyUserRegistration extends ConsumerWidget {
  const _VerifyUserRegistration();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<bool> isUserRegistered = ref.watch(isUserRegisteredProvider);

    return isUserRegistered.when(
      loading: () => const LoadingPage(),
      error: (error, stackTrace) => ErrorPage(error),
      data: (isUserRegistered) {
        if (!isUserRegistered) {
          return const RegisterPage();
        }

        return const MainPagesWrapper();
      },
    );
  }
}
