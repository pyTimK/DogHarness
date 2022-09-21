import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      child: PageScrollLayout(
        padding: const EdgeInsets.all(0),
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: MyStyles.dark,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
