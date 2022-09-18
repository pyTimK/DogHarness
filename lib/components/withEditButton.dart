import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WithEditButton extends StatefulWidget {
  const WithEditButton({required this.child, required this.onEdit, super.key});
  final Widget child;
  final VoidCallback onEdit;

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
            size: const Size.fromRadius(50), // Image radius
            child: widget.child,
          ),
        ),
        GestureDetector(
          onTap: widget.onEdit,
          child: SvgPicture.asset("assets/svg/edit-avatar.svg"),
        )
      ],
    );
  }
}
