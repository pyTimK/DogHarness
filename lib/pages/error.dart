import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage(this.error, {super.key});
  final Object error;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
      child: Text("Error: ${error.toString()}"),
    );
  }
}
