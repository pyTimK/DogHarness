import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myDayInput.dart';
import 'package:bluetooth_app_test/components/myDropdown.dart';
import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/enums/button_state.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/models/record.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/services/storage/firebase_storage.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends ConsumerState<RegisterPage> {
  final _ownerNicknameController = TextEditingController();
  final _dogNameController = TextEditingController();
  final _dogBreedController = MyDropdownController<DogBreed>();
  final _dogSizeController = MyDropdownController<DogSize>();
  final _birthdayController = MyDayInputController();
  final _ownerAvatarController = MyEditableAvatarController();
  final _dogAvatarController = MyEditableAvatarController();
  final _formKey = GlobalKey<FormState>();

  var _continueButtonState = ButtonState.enabled;

  void _setContinueButtonLoading(ButtonState state) {
    if (mounted) {
      setState(() {
        _continueButtonState = state;
      });
    }
  }

  _openAddFriendsDogDialog() {
    //TODO
  }

  _register(User? user) async {
    if (_formKey.currentState!.validate() && user != null) {
      logger.i("Registering user ${user.uid}...");
      _setContinueButtonLoading(ButtonState.loading);
      try {
        // generate Ids
        final ownerId = user.uid;
        final dogId = CloudFirestoreService.generateDogId;

        await CloudFirestoreService.registerOwner(
          user: user,
          ownerAvatar: _ownerAvatarController.value,
          nickname: _ownerNicknameController.text,
          defaultDogId: dogId,
        );

        await CloudFirestoreService.registerDog(
          id: dogId,
          avatar: _dogAvatarController.value,
          name: _dogNameController.text,
          breed: _dogBreedController.value!,
          size: _dogSizeController.value!,
          birthday: _birthdayController.value!,
          ownerId: ownerId,
        );

        await CloudFirestoreService.setRecord(Record.fromNull(dogId));
        ref.read(isUserRegisteredProvider.notifier).setIsUserRegistered(true);
        logger.i("Registered user ${user.uid}...");
      } catch (e) {
        logger.e(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: MyStyles.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      _setContinueButtonLoading(ButtonState.enabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value;

    return Form(
      key: _formKey,
      child: PageLayout(
        child: PageScrollLayout(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
          children: [
            const SizedBox(height: 30),
            const Text("Tell us about both of you", style: MyStyles.h1),
            const Text("Please fill in the following details.", style: MyStyles.p),
            const SizedBox(height: 50),
            const Text("OWNER", style: MyStyles.h2),
            const SizedBox(height: 35),
            MyEditableAvatar(
              controller: _ownerAvatarController,
              defaultImage: SvgPicture.asset("assets/svg/owner-empty-avatar.svg", fit: BoxFit.cover),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 60),
            const Text("DOG", style: MyStyles.h2),
            const SizedBox(height: 35),
            MyEditableAvatar(
              controller: _dogAvatarController,
              defaultImage: SvgPicture.asset("assets/svg/dog-empty-avatar.svg", fit: BoxFit.cover),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
            MyDayInput(
              controller: _birthdayController,
              label: "Brithday",
              validator: (DateTime? value) {
                if (value == null) {
                  return "Birthday cannot be empty";
                }
              },
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
            const SizedBox(height: 20),
            MyButton(
              label: "CONTINUE",
              state: _continueButtonState,
              onPressed: () => _register(user),
            ),
          ],
        ),
      ),
    );
  }
}
