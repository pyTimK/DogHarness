import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage(this.error, {super.key});
  final Object error;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      child: PageScrollLayout(
        padding: const EdgeInsets.all(0),
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
              child: Text("Error: ${error.toString()}"),
            ),
          ),
        ],
      ),
    );
  }
}
