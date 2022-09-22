import 'package:blobs/blobs.dart';
import 'package:bluetooth_app_test/components/bouncing.dart';
import 'package:bluetooth_app_test/components/myAlertDialog.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/components/rotatingBlobs.dart';
import 'package:bluetooth_app_test/functions/signout.dart';
import 'package:bluetooth_app_test/providers.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/services/storage/firebase_storage.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends ConsumerState<AccountPage> with AutomaticKeepAliveClientMixin<AccountPage> {
  final _ownerAvatarController = MyEditableAvatarController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var owner = ref.watch(ownerProvider).value;
    var dogs = ref.watch(dogsProvider).value;

    void _openAddDogDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog(children: [
            const Text("Add a dog", style: MyStyles.h1),
            const SizedBox(height: 15),
            MyButton.outlineShrink(
                label: "CREATE A NEW PROFILE",
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/addDog");
                }),
            const SizedBox(height: 7),
            const Text("OR", style: MyStyles.p),
            const SizedBox(height: 7),
            MyButton.outlineShrink(label: "ADD MY FRIEND'S DOG", onPressed: () {}),
          ]);
        },
      );
    }

    return PageScrollLayout(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Profile", style: MyStyles.h1),
        const SizedBox(height: 30),
        Stack(
          alignment: Alignment.center,
          children: [
            const RotatingBlobs(),
            MyEditableAvatar(
              controller: _ownerAvatarController,
              defaultImage: owner != null
                  ? MyCircleAvatar.owner(owner)
                  : SvgPicture.asset("assets/svg/owner-empty-avatar.svg", fit: BoxFit.cover),
              radius: 70,
              onChanged: (image) async {
                if (owner == null) return;
                final newPhotoUrl =
                    await FirebaseStorageService.uploadImage(id: owner.id, image: _ownerAvatarController.value);
                if (newPhotoUrl == null) return;
                await CachedNetworkImage.evictFromCache(newPhotoUrl);
                await CloudFirestoreService.updateOwner(owner.copyWith(photoUrl: newPhotoUrl));
              },
            ),
          ],
        ),
        Text(owner?.nickname ?? "", style: MyStyles.title),
        const SizedBox(height: 5),
        Text(owner?.email ?? "", style: MyStyles.h2.weight(FontWeight.w300)),
        const SizedBox(height: 65),
        const Text("OWNER", style: MyStyles.h2),
        const SizedBox(height: 25),
        TextFormField(
          decoration: MyStyles.myInputDecoration("Nickname"),
          initialValue: owner?.nickname,
          style: MyStyles.h2,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please enter your nickname";
            }

            return null;
          },
          onChanged: (String value) {
            if (owner == null) return;
            CloudFirestoreService.updateOwner(owner.copyWith(nickname: value));
            // ref.read(ownerProvider).state = owner?.copyWith(nickname: value);
          },
        ),
        const SizedBox(height: 35),
        const Text("DOGS", style: MyStyles.h2),
        const SizedBox(height: 35),
        if (dogs != null)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemCount: dogs.length,
            itemBuilder: (context, index) {
              final dog = dogs[index];
              return Bouncing(
                onPress: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: MyStyles.dark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    textColor: MyStyles.white,
                    leading: MyCircleAvatar.dog(dog),
                    title: Text(dog.name, style: MyStyles.h2),
                    subtitle: Text("${dog.breed}", style: MyStyles.p),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          ),
        const SizedBox(height: 30),
        MyButton.outlineShrink(
          label: "NEW DOG",
          onPressed: _openAddDogDialog,
        ),
        const SizedBox(height: 90),
        MyButton.shrink(
          color: MyStyles.red,
          label: "Sign Out",
          onPressed: () {
            signOut(ref);
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
