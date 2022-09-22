import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myDayInput.dart';
import 'package:bluetooth_app_test/components/myDropdown.dart';
import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/enums/button_state.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/pages/pushedPages/pushedPageLayout.dart';
import 'package:bluetooth_app_test/providers.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/services/storage/firebase_storage.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddDogPage extends ConsumerStatefulWidget {
  const AddDogPage({super.key});

  @override
  AddDogPageState createState() => AddDogPageState();
}

class AddDogPageState extends ConsumerState<AddDogPage> {
  final _dogNameController = TextEditingController();
  final _dogBreedController = MyDropdownController<DogBreed>();
  final _dogSizeController = MyDropdownController<DogSize>();
  final _birthdayController = MyDayInputController();
  final _dogAvatarController = MyEditableAvatarController();
  final _formKey = GlobalKey<FormState>();
  var _addButtonState = ButtonState.enabled;

  void _setAddButtonLoading(ButtonState state) {
    if (mounted) {
      setState(() {
        _addButtonState = state;
      });
    }
  }

  void _addDog() async {
    final owner = ref.read(ownerProvider).value;

    if (owner == null) return;

    if (_formKey.currentState!.validate()) {
      _setAddButtonLoading(ButtonState.loading);
      final dogId = CloudFirestoreService.generateDogId;

      await CloudFirestoreService.registerDog(
        id: dogId,
        avatar: _dogAvatarController.value,
        name: _dogNameController.text,
        breed: _dogBreedController.value!,
        size: _dogSizeController.value!,
        birthday: _birthdayController.value!,
        ownerId: owner.id,
      );

      await CloudFirestoreService.updateOwner(owner.copyWith(dogIds: [...owner.dogIds, dogId], defaultDogId: dogId));

      if (mounted) {
        Navigator.pop(context);
      }
      _setAddButtonLoading(ButtonState.enabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: PushedPageLayout(
        crossAxisAlignment: CrossAxisAlignment.center,
        title: "Add a Dog",
        children: [
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
          const SizedBox(height: 30),
          MyButton.shrink(
            label: "ADD",
            state: _addButtonState,
            color: MyStyles.green,
            onPressed: _addDog,
          ),
        ],
      ),
    );
  }
}
