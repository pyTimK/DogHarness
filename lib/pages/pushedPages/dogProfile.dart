import 'dart:io';

import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/components/myDayInput.dart';
import 'package:bluetooth_app_test/components/myDropdown.dart';
import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/myListTiles.dart';
import 'package:bluetooth_app_test/components/rotatingBlobs.dart';
import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/pages/pushedPages/pushedPageLayout.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/services/storage/firebase_storage.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DogProfilePage extends ConsumerStatefulWidget {
  const DogProfilePage({super.key});

  @override
  DogProfilePageState createState() => DogProfilePageState();
}

class DogProfilePageState extends ConsumerState<DogProfilePage> {
  final _dogAvatarController = MyEditableAvatarController();

  void onDogAvatarChanged(File image, Dog dog) async {
    final newPhotoUrl = await FirebaseStorageService.uploadImage(id: dog.id, image: image, isOwner: false);
    if (newPhotoUrl == null) return;
    await CachedNetworkImage.evictFromCache(newPhotoUrl);
    await CloudFirestoreService.updateDog(dog.copyWith(photoUrl: newPhotoUrl));
  }

  void onDogNameChanged(String name, Dog dog) {
    CloudFirestoreService.updateDog(dog.copyWith(name: name));
  }

  void onDogBreedChanged(DogBreed breed, Dog dog) {
    CloudFirestoreService.updateDog(dog.copyWith(breed: breed));
  }

  void onDogSizeChanged(DogSize size, Dog dog) {
    CloudFirestoreService.updateDog(dog.copyWith(size: size));
  }

  void onDogBirthdayChanged(DateTime birthday, Dog dog) {
    CloudFirestoreService.updateDog(dog.copyWith(birthday: birthday));
  }

  Future<void> share(Dog dog) async {
    await FlutterShare.share(
      title: 'DOG CODE',
      text: dog.id,
      // text: 'Here is the code of ${dog.name}:\n${dog.id}',
    );
  }

  void goToOwner(Owner owner) {
    ref.read(viewingOwnerProvider.notifier).state = owner;
    Navigator.of(context).pushReplacementNamed(RouteNames.ownerProfile);
  }

  @override
  Widget build(BuildContext context) {
    final dog = ModalRoute.of(context)!.settings.arguments as Dog;
    final owner = ref.watch(ownerProvider).value;
    final viewingDogsOwner = ref.watch(viewingDogsOwnerProvider).value;
    final viewingDogsHumanBuddies = ref.watch(viewingDogsHumanBuddiesProvider).value;
    final ownedDog = owner != null && dog.ownerId == owner.id;

    return PushedPageLayout(
      crossAxisAlignment: CrossAxisAlignment.center,
      title: "Dog Profile",
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const RotatingBlobs(),
            MyEditableAvatar(
              controller: _dogAvatarController,
              defaultImage: MyCircleAvatar.dog(dog),
              radius: 70,
              onChanged: (image) => onDogAvatarChanged(image, dog),
              isEditable: ownedDog,
            ),
          ],
        ),
        Text(dog.name, style: MyStyles.title),
        const SizedBox(height: 5),
        Text("${dog.breed}", style: MyStyles.h2.weight(FontWeight.w300)),
        const SizedBox(height: 25),
        if (ownedDog) ...[
          TextFormField(
            decoration: MyStyles.myInputDecoration("Name"),
            style: MyStyles.h2,
            initialValue: dog.name,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Name cannot be empty";
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) => onDogNameChanged(value, dog),
          ),
          const SizedBox(height: 20),
          MyDrowpdown(
            hint: "Choose Breed",
            label: "Breed",
            initialValue: dog.breed,
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
            onChanged: (value) => onDogBreedChanged(value, dog),
          ),
          const SizedBox(height: 20),
          MyDrowpdown(
            hint: "Choose Size",
            label: "Size",
            initialValue: dog.size,
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
            onChanged: (value) => onDogSizeChanged(value, dog),
          ),
          const SizedBox(height: 20),
          MyDayInput(
            label: "Brithday",
            initialValue: dog.birthday,
            validator: (DateTime? value) {
              if (value == null) {
                return "Birthday cannot be empty";
              }
            },
            onChanged: (value) => onDogBirthdayChanged(value, dog),
          ),
          const SizedBox(height: 30),
          MyButton.icon(
            label: "SHARE DOG CODE",
            icon: SvgPicture.asset(
              "assets/svg/share-outline.svg",
              color: Colors.white,
            ),
            color: MyStyles.blue,
            onPressed: () => share(dog),
          ),
          const SizedBox(height: 65),
        ],
        const Text("OWNER", style: MyStyles.h2),
        const SizedBox(height: 35),
        if (viewingDogsOwner != null) OwnerListView(owners: [viewingDogsOwner], onPressed: goToOwner),
        const SizedBox(height: 45),
        if (viewingDogsHumanBuddies != null && viewingDogsHumanBuddies.isNotEmpty) ...[
          const Text("HUMAN BUDDIES", style: MyStyles.h2),
          const SizedBox(height: 35),
          OwnerListView(owners: viewingDogsHumanBuddies, onPressed: goToOwner),
        ],
      ],
    );
  }
}
