import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WithEditButton extends StatefulWidget {
  const WithEditButton(
      {required this.child, required this.onEdit, this.radius = 50, this.isEditable = true, super.key});
  final Widget child;
  final VoidCallback onEdit;
  final double radius;
  final bool isEditable;

  @override
  State<WithEditButton> createState() => _WithEditButtonState();
}

class _WithEditButtonState extends State<WithEditButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: Size.fromRadius(widget.radius), // Image radius
            child: widget.child,
          ),
        ),
        if (widget.isEditable)
          GestureDetector(
            onTap: widget.onEdit,
            child: SvgPicture.asset("assets/svg/edit-avatar.svg"),
          )
      ],
    );
  }
}
