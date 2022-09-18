import 'dart:io';
import 'package:bluetooth_app_test/components/myAlertDialog.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myDropdown.dart';
import 'package:bluetooth_app_test/components/withEditButton.dart';
import 'package:bluetooth_app_test/functions/capture_image.dart';
import 'package:bluetooth_app_test/functions/pick_image.dart';
import 'package:bluetooth_app_test/functions/utils.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _ownerNicknameController = TextEditingController();
  final TextEditingController _dogNameController = TextEditingController();
  final MyDropdownController<DogBreed> _dogBreedController = MyDropdownController();
  final MyDropdownController<DogSize> _dogSizeController = MyDropdownController();
  DateTime? _birthday;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _ownerImage;
  File? _dogImage;

  Future<void> _updateImage(Future<File?> Function() getImage, {bool isOwner = true}) async {
    final image = await getImage();
    if (image != null && mounted) {
      Navigator.pop(context);
      setState(() {
        if (isOwner) {
          _ownerImage = image;
        } else {
          _dogImage = image;
        }
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

  _openAddFriendsDogDialog() {
    //TODO
  }

  _register() {
    if (_formKey.currentState!.validate()) {
      final user = Provider.of<User>(context, listen: false);
      final owner = Owner(
        nickname: _ownerNicknameController.text,
        email: user.email!,
        photoUrl: user.photoURL,
        dogIds: [],
      );

      // final dog = Dog(
      //   name: _dogNameController.text,
      //   breed: _dogBreedController.value,
      //   size: _dogSizeController.value,
      //   birthday: _birthday,
      //   owner: owner,
      //   photoUrl: user.photoURL,
      // );
      //TODO: birthday validator
      //TODO: call firestore register
      //TODO: save profile images in firebase storage
      //TODO: update owner/dog photoUrls in firestore
    }
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _birthday = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Tell us about both of you", style: MyStyles.h1),
            const Text("Please fill in the following details.", style: MyStyles.p),
            const SizedBox(height: 50),
            const Text("OWNER", style: MyStyles.h2),
            const SizedBox(height: 35),
            WithEditButton(
              onEdit: _openChangePictureDialog,
              child: _ownerImage == null
                  ? SvgPicture.asset("assets/svg/owner-empty-avatar.svg", fit: BoxFit.cover)
                  : Image.file(_ownerImage!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _ownerNicknameController,
              decoration: MyStyles.myInputDecoration("Nickname"),
              style: MyStyles.h2,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Nickname cannot be empty";
                }
              },
            ),
            const SizedBox(height: 60),
            const Text("DOG", style: MyStyles.h2),
            const SizedBox(height: 35),
            WithEditButton(
              onEdit: () => _openChangePictureDialog(isOwner: false),
              child: _ownerImage == null
                  ? SvgPicture.asset("assets/svg/dog-empty-avatar.svg", fit: BoxFit.cover)
                  : Image.file(_dogImage!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _dogNameController,
              decoration: MyStyles.myInputDecoration("Name"),
              style: MyStyles.h2,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Name cannot be empty";
                }
              },
            ),
            const SizedBox(height: 20),
            MyDrowpdown(
              controller: _dogBreedController,
              hint: "Choose Breed",
              label: "Breed",
              items: DogBreed.all
                  .map((breed) => DropdownMenuItem(
                        value: breed,
                        child: Text(
                          breed.toString(),
                          style: MyStyles.h2,
                        ),
                      ))
                  .toList(),
              validator: (DogBreed? value) {
                if (value == null) {
                  return "Breed cannot be empty";
                }
              },
            ),
            const SizedBox(height: 20),
            MyDrowpdown(
              controller: _dogSizeController,
              hint: "Choose Size",
              label: "Size",
              items: DogSize.all
                  .map((size) => DropdownMenuItem(
                        value: size,
                        child: Text(
                          size.toString(),
                          style: MyStyles.h2,
                        ),
                      ))
                  .toList(),
              validator: (DogSize? value) {
                if (value == null) {
                  return "Size cannot be empty";
                }
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MyStyles.dark),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _birthday == null
                          ? Text("Birthday", style: MyStyles.h2.colour(MyStyles.dark60))
                          : Text(getFormattedDate(_birthday!), style: MyStyles.h2),
                      SvgPicture.asset(
                        "assets/svg/calendar.svg",
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            const Text("OR", style: MyStyles.h3),
            const SizedBox(height: 20),
            MyButton.outlineShrink(
              label: "ADD MY FRIEND'S DOG",
              onPressed: _openAddFriendsDogDialog,
            ),
            const SizedBox(height: 20),
            const Text("Note: You can add another dog later", style: MyStyles.p),
            const SizedBox(height: 60),
            MyButton(label: "CONTINUE", onPressed: _register),
          ],
        ),
      ),
    );
  }
}
