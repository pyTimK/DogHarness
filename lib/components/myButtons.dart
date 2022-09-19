import 'package:bluetooth_app_test/components/bouncing.dart';
import 'package:bluetooth_app_test/enums/button_state.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    required this.label,
    this.color = MyStyles.dark,
    required this.onPressed,
    this.labelColor = MyStyles.white,
    this.dense = false,
    this.state = ButtonState.enabled,
    super.key,
  })  : shrink = false,
        outline = false,
        outlineColor = null,
        icon = null;

  const MyButton.icon({
    required this.label,
    this.color = MyStyles.dark,
    required this.onPressed,
    this.labelColor = MyStyles.white,
    required this.icon,
    this.dense = false,
    this.state = ButtonState.enabled,
    super.key,
  })  : shrink = false,
        outline = false,
        outlineColor = null;

  const MyButton.shrink({
    required this.label,
    this.color = MyStyles.dark,
    required this.onPressed,
    this.labelColor = MyStyles.white,
    this.dense = false,
    this.state = ButtonState.enabled,
    super.key,
  })  : shrink = true,
        outline = false,
        outlineColor = null,
        icon = null;

  const MyButton.outline({
    required this.label,
    required this.onPressed,
    this.labelColor = MyStyles.dark,
    this.outlineColor = MyStyles.dark,
    this.dense = false,
    this.state = ButtonState.enabled,
    super.key,
  })  : color = null,
        shrink = false,
        outline = true,
        icon = null;

  const MyButton.outlineShrink({
    required this.label,
    required this.onPressed,
    this.labelColor = MyStyles.dark,
    this.outlineColor = MyStyles.dark,
    this.dense = false,
    this.state = ButtonState.enabled,
    super.key,
  })  : color = null,
        shrink = true,
        outline = true,
        icon = null;

  const MyButton.outlineIcon({
    required this.label,
    required this.onPressed,
    required this.icon,
    this.labelColor = MyStyles.dark,
    this.outlineColor = MyStyles.dark,
    this.dense = false,
    this.state = ButtonState.enabled,
    super.key,
  })  : color = null,
        shrink = false,
        outline = true;

  final Color? color;
  final String label;
  final Color labelColor;
  final void Function() onPressed;
  final bool shrink;
  final bool outline;
  final Color? outlineColor;
  final Widget? icon;
  final bool dense;
  final ButtonState state;

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(outline ? Colors.transparent : color ?? MyStyles.dark),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: (shrink || dense) ? 10 : 20, horizontal: 35)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          side: outline ? BorderSide(color: outlineColor ?? MyStyles.dark) : BorderSide.none)),
      overlayColor: MaterialStateProperty.all(outline ? MyStyles.dark10 : MyStyles.white10),
    );

    Text labelWidget = Text(state == ButtonState.loading ? "" : label, style: MyStyles.h3.colour(labelColor));

    Widget textButton = icon == null
        ? TextButton(
            style: buttonStyle,
            onPressed: state != ButtonState.enabled ? null : onPressed,
            child: labelWidget,
          )
        : TextButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(dense ? -20 : -10, 0),
                  child: Align(alignment: Alignment.centerLeft, child: icon!),
                ),
                Align(alignment: Alignment.center, child: labelWidget)
              ],
            ),
          );

    textButton = shrink ? textButton : SizedBox(width: double.infinity, child: textButton);

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        textButton,
        if (state == ButtonState.loading)
          LoadingAnimationWidget.staggeredDotsWave(
            color: outline ? MyStyles.dark : MyStyles.white,
            size: shrink ? 15 : 30,
          ),
      ],
    );
  }
}
