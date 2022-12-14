import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyDogDropdown extends ConsumerStatefulWidget {
  const MyDogDropdown({this.controller, this.onChanged, super.key}) : assert(controller != null || onChanged != null);
  final MyDogDropdownController? controller;
  final ValueChanged<Dog?>? onChanged;

  @override
  MyDogDropdownState createState() => MyDogDropdownState();
}

class MyDogDropdownState extends ConsumerState<MyDogDropdown> {
  _setValue(Dog? dog) async {
    final owner = ref.read(ownerProvider).value;
    if (owner == null) return;

    widget.onChanged?.call(dog);
    widget.controller?.value = dog;
    await CloudFirestoreService.updateOwner(owner.copyWith(defaultDogId: dog?.id));
  }

  @override
  void initState() {
    super.initState();
    final defaultDog = ref.read(defaultDogProvider);
    widget.controller?.value = defaultDog;
  }

  @override
  Widget build(BuildContext context) {
    var dogs = ref.watch(dogsProvider).value;
    var defaultDog = ref.watch(defaultDogProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        // side: const BorderSide(color: MyStyles.dark),
      ),
      child: DropdownButton<Dog>(
        items: dogs == null
            ? []
            : dogs
                .map((dog) => DropdownMenuItem<Dog>(
                      value: dog,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: MyCircleAvatar.dog(dog, radius: 16),
                          ),
                          Text(dog.name, style: MyStyles.h3),
                        ],
                      ),
                    ))
                .toList(),
        value: defaultDog,
        onChanged: _setValue,
        dropdownColor: MyStyles.white,
        elevation: 3,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        underline: const SizedBox(),
      ),
    );
  }
}

class MyDogDropdownController {
  Dog? value;
}
