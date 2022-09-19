import 'dart:async';

import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/pages/login.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkIfEmailVerified();
    });
  }

  _sendVerificationEmail() async {
    var user = Provider.of<User>(context, listen: false);
    await user.reload();
    try {
      if (user.emailVerified) {
        throw Exception('Email already verified');
      }
      logger.wtf("Email Verified? ${user.emailVerified}");
      logger.wtf(user.emailVerified);
      await user.sendEmailVerification();
      await user.reload();
    } catch (e) {
      logger.e(e);
    }
  }

  _checkIfEmailVerified() async {
    var user = Provider.of<User>(context, listen: false);
    await user.reload();
    // if (user.emailVerified) {
    //   _timer.cancel();
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => const LogInPage(),
    //     ),
    //   );
    // }
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
      child: Transform.translate(
        offset: const Offset(0, -100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/svg/mail-sent.svg",
              height: 175,
            ),
            const SizedBox(height: 30),
            const Text(
              'Verify your email',
              style: MyStyles.h1,
            ),
            const SizedBox(height: 5),
            Text(
              'We have sent an email to ${user.email}. Please click on the link to verify your email address.',
              textAlign: TextAlign.center,
              style: MyStyles.p,
            ),
            const SizedBox(height: 30),
            const Text("Different Email?", style: MyStyles.p),
            const SizedBox(height: 5),
            MyButton.outlineShrink(
              label: "Change Email",
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}
