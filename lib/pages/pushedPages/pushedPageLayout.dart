import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PushedPageLayout extends StatelessWidget {
  const PushedPageLayout(
      {required this.title,
      required this.children,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
      super.key});
  final String title;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      child: PageScrollLayout(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        padding: padding,
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              IconButton(
                iconSize: 50,
                icon: const Icon(Icons.chevron_left_rounded, color: MyStyles.dark),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(0),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Center(child: Text(title, style: MyStyles.h1)),
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: children,
              ))
        ],
      ),
    );
  }
}
