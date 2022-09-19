import 'package:bluetooth_app_test/change_notifiers/account_data.dart';
import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final accountData = Provider.of<AccountData>(context);
    var owner = accountData.owner;
    var dog = accountData.defaultDog;
    var dogs = accountData.dogs;
    logger.wtf(dog);
    logger.wtf(dogs);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyCircleAvatar.owner(owner),
          const SizedBox(height: 20),
          Text("Hi ${owner?.nickname ?? ""}", style: MyStyles.h1),
          const SizedBox(height: 3),
          //TODO: make quote dynamic
          const Text("Dog is God spelled backward.", style: MyStyles.p),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  // side: const BorderSide(color: MyStyles.dark),
                ),
                child: DropdownButton<Dog>(
                  items: dogs
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
                  value: dog,
                  onChanged: (Dog? dog) {},
                  dropdownColor: MyStyles.white,
                  elevation: 3,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  underline: const SizedBox(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
