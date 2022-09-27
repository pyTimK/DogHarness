import 'dart:io';

import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/myListTiles.dart';
import 'package:bluetooth_app_test/components/rotatingBlobs.dart';
import 'package:bluetooth_app_test/constants.dart';
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
import 'package:flutter_svg/flutter_svg.dart';

class OwnerProfilePage extends ConsumerStatefulWidget {
  const OwnerProfilePage({super.key});

  @override
  OwnerProfilePageState createState() => OwnerProfilePageState();
}

class OwnerProfilePageState extends ConsumerState<OwnerProfilePage> {
  @override
  Widget build(BuildContext context) {
    final viewingOwner = ref.watch(viewingOwnerProvider);
    final viewingOwnersDogs = ref.watch(viewingOwnersDogsProvider).value;

    return PushedPageLayout(
      title: "Owner Profile",
      children: [
        OwnerProfile(
          owner: viewingOwner,
          dogs: viewingOwnersDogs,
          isPushed: true,
        )
      ],
    );
  }
}

class OwnerProfile extends ConsumerStatefulWidget {
  const OwnerProfile({required this.owner, required this.dogs, this.isPushed = false, super.key});
  final Owner? owner;
  final List<Dog>? dogs;
  final bool isPushed;

  @override
  OwnerProfileState createState() => OwnerProfileState();
}

class OwnerProfileState extends ConsumerState<OwnerProfile> {
  final _ownerAvatarController = MyEditableAvatarController();

  void onOwnerAvatarChanged(File image, Owner? owner) async {
    if (owner == null) return;
    final newPhotoUrl = await FirebaseStorageService.uploadImage(id: owner.id, image: image);
    if (newPhotoUrl == null) return;
    await CachedNetworkImage.evictFromCache(newPhotoUrl);
    await CloudFirestoreService.updateOwner(owner.copyWith(photoUrl: newPhotoUrl));
  }

  void onOwnerNicknameChanged(String nickname, Owner? owner) {
    if (owner == null) return;
    CloudFirestoreService.updateOwner(owner.copyWith(nickname: nickname));
  }

  void goToDogProfile(Dog dog) {
    ref.read(viewingDogProvider.notifier).state = dog;
    if (widget.isPushed) {
      Navigator.of(context).pushReplacementNamed(RouteNames.dogProfile, arguments: dog);
    } else {
      Navigator.of(context).pushNamed(RouteNames.dogProfile, arguments: dog);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountOwner = ref.watch(ownerProvider).value;
    final ownedOwner = accountOwner != null && widget.owner?.id == accountOwner.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const RotatingBlobs(),
            MyEditableAvatar(
              controller: _ownerAvatarController,
              defaultImage: widget.owner != null
                  ? MyCircleAvatar.owner(widget.owner)
                  : SvgPicture.asset("assets/svg/owner-empty-avatar.svg", fit: BoxFit.cover),
              radius: 70,
              onChanged: (image) => onOwnerAvatarChanged(image, widget.owner),
              isEditable: ownedOwner,
            ),
          ],
        ),
        Text(widget.owner?.nickname ?? "", style: MyStyles.title),
        const SizedBox(height: 5),
        Text(widget.owner?.email ?? "", style: MyStyles.h2.weight(FontWeight.w300)),
        if (ownedOwner) ...[
          const SizedBox(height: 35),
          TextFormField(
            decoration: MyStyles.myInputDecoration("Nickname"),
            initialValue: widget.owner?.nickname,
            style: MyStyles.h2,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Please enter your nickname";
              }

              return null;
            },
            onChanged: (value) => onOwnerNicknameChanged(value, widget.owner),
          ),
        ],
        if (widget.dogs != null && widget.dogs!.isNotEmpty) ...[
          const SizedBox(height: 35),
          const Text("DOGS", style: MyStyles.h2),
          const SizedBox(height: 35),
          DogListView(
            dogs: widget.dogs!,
            onPressed: goToDogProfile,
          ),
        ]
      ],
    );
  }
}
