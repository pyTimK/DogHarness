import 'dart:io';

import 'package:blobs/blobs.dart';
import 'package:bluetooth_app_test/components/bouncing.dart';
import 'package:bluetooth_app_test/components/myAlertDialog.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/myListTiles.dart';
import 'package:bluetooth_app_test/components/myText.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/components/rotatingBlobs.dart';
import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/enums/button_state.dart';
import 'package:bluetooth_app_test/functions/signout.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/pages/pushedPages/ownerProfile.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/services/storage/firebase_storage.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends ConsumerState<AccountPage> with AutomaticKeepAliveClientMixin<AccountPage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _addButtonState = ButtonState.enabled;

  @override
  bool get wantKeepAlive => true;

  void setAddButtonState(ButtonState state) {
    setState(() {
      _addButtonState = state;
    });
  }

  void openAddDogDialog(Owner? owner) {
    if (owner == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(children: [
          const MyText.h1("Add a dog"),
          const SizedBox(height: 15),
          MyButton.outlineShrink(
              label: "CREATE A NEW PROFILE",
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RouteNames.addDog);
              }),
          const SizedBox(height: 7),
          const MyText("OR"),
          const SizedBox(height: 7),
          MyButton.outlineShrink(
              label: "ADD MY FRIEND'S DOG",
              onPressed: () {
                Navigator.of(context).pop();
                openAddFriendsDogDialog(owner);
              }),
        ]);
      },
    );
  }

  void openAddFriendsDogDialog(Owner owner) {
    _codeController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: MyAlertDialog(children: [
            const Text("Add a friend's dog", style: MyStyles.h1),
            const SizedBox(height: 15),
            TextFormField(
              controller: _codeController,
              decoration: MyStyles.myInputDecoration("Code"),
              style: MyStyles.h2,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a valid code";
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 10),
            const Text("Note: You can ask your friend to share the code from the dog's profile", style: MyStyles.p),
            const SizedBox(height: 25),
            MyButton.shrink(
                label: "ADD",
                color: MyStyles.green,
                dense: true,
                state: _addButtonState,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final dogId = _codeController.text;
                    if (owner.dogIds.contains(dogId)) {
                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You already have this dog in your account"),
                            backgroundColor: MyStyles.red,
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }

                      return;
                    }
                    setAddButtonState(ButtonState.loading);
                    try {
                      await CloudFirestoreService.addDogToOwner(owner: owner, dogId: dogId);
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      logger.e(e);
                    }
                    setAddButtonState(ButtonState.enabled);
                  }
                }),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var owner = ref.watch(ownerProvider).value;
    var dogs = ref.watch(dogsProvider).value;

    return PageScrollLayout(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        const MyText.h1("Profile"),
        const SizedBox(height: 30),
        OwnerProfile(owner: owner, dogs: dogs),
        const SizedBox(height: 30),
        MyButton.outlineShrink(
          label: "NEW DOG",
          onPressed: () => openAddDogDialog(owner),
        ),
        const SizedBox(height: 50),
        MyButton.shrink(
          color: MyStyles.red,
          label: "Sign Out",
          onPressed: () {
            signOut(ref);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
