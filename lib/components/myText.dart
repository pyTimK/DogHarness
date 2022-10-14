import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? color;

  const MyText(this.text, {this.color, super.key}) : style = MyStyles.p;

  const MyText.h1(this.text, {this.color, super.key}) : style = MyStyles.h1;

  const MyText.h2(this.text, {this.color, super.key}) : style = MyStyles.h2;

  const MyText.h2Regular(this.text, {this.color, super.key}) : style = MyStyles.h2Regular;

  const MyText.h3(this.text, {this.color, super.key}) : style = MyStyles.h3;

  const MyText.title(this.text, {this.color, super.key}) : style = MyStyles.title;

  const MyText.p(this.text, {this.color, super.key}) : style = MyStyles.p;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style.copyWith(color: color));
  }
}
