import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/functions/is_email.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

enum _LogInPageType {
  login,
  signup,
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _pageType = _LogInPageType.login;
  bool _hasInputError = false;

  _showError(String error) {
    if (mounted) {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: MyStyles.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  _login(String email, String password) async {
    setState(() {
      _hasInputError = false;
    });

    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showError('Invalid Email or Password');
      } else if (e.code == 'wrong-password') {
        _showError('Invalid Email or Password');
      }
    }
  }

  _signup(String email, String password) async {
    setState(() {
      _hasInputError = false;
    });

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showError('The password is too weak');
      } else if (e.code == 'email-already-in-use') {
        if (mounted) {
          await _login(email, password);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      child: PageScrollLayout(
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: [
          const SizedBox(height: 70),
          Image.asset(
            "assets/icon/icon-transparent.png",
            height: 176,
          ),
          const SizedBox(height: 30),
          const Text(Constants.appName, style: MyStyles.h1),
          const SizedBox(height: 5),
          const Text("Welcome Dog Lover!", style: MyStyles.p),
          const SizedBox(height: 55),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: MyStyles.myInputDecoration("Email"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: MyStyles.h2,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }

                    if (!isEmail(value)) {
                      return "Please enter a valid email";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 25),
                TextFormField(
                  //TODO: Dont show password plain text
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: MyStyles.myInputDecoration("Password"),
                  style: MyStyles.h2,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 25),
                MyButton(
                  label: _pageType == _LogInPageType.login ? "LOGIN" : "SIGN UP",
                  onPressed: () {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      if (_pageType == _LogInPageType.login) {
                        _login(_emailController.text, _passwordController.text);
                      } else {
                        _signup(_emailController.text, _passwordController.text);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("OR", style: MyStyles.h3),
          const SizedBox(height: 20),
          MyButton.outlineIcon(
            label: "SIGN IN WITH GOOGLE",
            icon: Image.asset("assets/images/google-icon.png"),
            onPressed: _signInWithGoogle,
          ),
          const SizedBox(height: 30),
          const Text("Don't have an account?", style: MyStyles.p),
          const SizedBox(height: 10),
          MyButton.outlineShrink(
            label: "SIGN UP",
            onPressed: () {
              setState(() {
                _pageType = _pageType == _LogInPageType.login ? _LogInPageType.signup : _LogInPageType.login;
              });
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
