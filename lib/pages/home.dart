import 'package:bluetooth_app_test/components/dayRows.dart';
import 'package:bluetooth_app_test/components/defaultDatePicker.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/components/myDogDropdown.dart';
import 'package:bluetooth_app_test/helpers/date_helper.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/providers.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  static const horizontalPadding = 20.0;
  final _dogDropdownController = MyDogDropdownController();
  @override
  Widget build(BuildContext context) {
    var owner = ref.watch(ownerProvider).value;
    var dogs = ref.watch(dogsProvider).value;
    var defaultDog = ref.watch(defaultDogProvider).value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HomePageState.horizontalPadding, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyCircleAvatar.owner(owner),
              const DefaultDatePicker(),
            ],
          ),
          const SizedBox(height: 20),
          Text("Hi ${owner?.nickname ?? ""}", style: MyStyles.h1),
          const SizedBox(height: 3),
          //TODO: make quote dynamic
          const Text("Dog is God spelled backward.", style: MyStyles.p),
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.centerRight,
            child: MyDogDropdown(controller: _dogDropdownController),
          ),
          const SizedBox(height: 35),
          const DayRows(),

          MyButton.outlineShrink(
            label: "Sign Out",
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}
