import 'dart:io';

import 'package:bluetooth_app_test/components/myAlertDialog.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/withEditButton.dart';
import 'package:bluetooth_app_test/functions/capture_image.dart';
import 'package:bluetooth_app_test/functions/pick_image.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyEditableAvatar extends StatefulWidget {
  const MyEditableAvatar(
      {required this.controller, required this.defaultImage, this.radius = 50, this.onChanged, super.key});
  final MyEditableAvatarController controller;
  final Widget defaultImage;
  final double radius;
  final Function(File)? onChanged;

  @override
  State<MyEditableAvatar> createState() => _MyEditableAvatarState();
}

class _MyEditableAvatarState extends State<MyEditableAvatar> {
  File? _value;

  Future<void> _updateImage(Future<File?> Function() getImage, {bool isOwner = true}) async {
    final image = await getImage();
    widget.controller.value = image;
    if (image != null && mounted) {
      widget.onChanged?.call(image);
      Navigator.pop(context);
      setState(() {
        _value = image;
      });
    }
  }

  _openChangePictureDialog({bool isOwner = true}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyAlertDialog(
          children: [
            const Text("Change Owner Pic", style: MyStyles.h1),
            const SizedBox(height: 20),
            MyButton.outlineIcon(
              icon: SvgPicture.asset("assets/svg/camera.svg", color: MyStyles.dark),
              label: "USE CAMERA",
              dense: true,
              onPressed: () => _updateImage(captureImage, isOwner: isOwner),
            ),
            const SizedBox(height: 8),
            const Text("OR", style: MyStyles.p),
            const SizedBox(height: 8),
            MyButton.outlineIcon(
              icon: SvgPicture.asset("assets/svg/cloud-upload.svg", color: MyStyles.dark),
              label: "UPLOAD IMAGE",
              dense: true,
              onPressed: () => _updateImage(pickImage, isOwner: isOwner),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WithEditButton(
      onEdit: () => _openChangePictureDialog(isOwner: false),
      radius: widget.radius,
      child: _value == null ? widget.defaultImage : Image.file(_value!, fit: BoxFit.cover),
    );
  }
}

class MyEditableAvatarController {
  MyEditableAvatarController();
  File? value;
}
