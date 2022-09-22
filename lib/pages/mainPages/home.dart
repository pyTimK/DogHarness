import 'package:bluetooth_app_test/classes/step_status.dart';
import 'package:bluetooth_app_test/components/boxData.dart';
import 'package:bluetooth_app_test/components/dayRows.dart';
import 'package:bluetooth_app_test/components/defaultDatePicker.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/components/myDogDropdown.dart';
import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/functions/signout.dart';
import 'package:bluetooth_app_test/helpers/date_helper.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/providers.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  static const horizontalPadding = 20.0;
  final _dogDropdownController = MyDogDropdownController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var owner = ref.watch(ownerProvider).value;
    var dogs = ref.watch(dogsProvider).value;
    var defaultDog = ref.watch(defaultDogProvider);
    var recordDate = ref.watch(recordDateProvider).value;
    bool hasRecordDate = recordDate != null && recordDate.hasData;

    return PageScrollLayout(
      padding: const EdgeInsets.symmetric(horizontal: HomePageState.horizontalPadding, vertical: 60),
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
        if (defaultDog != null && hasRecordDate)
          Column(
            children: [
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BoxData(
                    recordDate.stepStatus,
                    onPress: () {},
                  ),
                  const SizedBox(width: 25),
                  BoxData(
                    recordDate.pulseStatus(defaultDog),
                    onPress: () {},
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BoxData(
                    recordDate.breathStatus,
                    onPress: () {},
                  ),
                  const SizedBox(width: 25),
                  BoxData(
                    recordDate.distanceStatus,
                    onPress: () {},
                  ),
                ],
              ),
            ],
          ),
        if (!hasRecordDate) ..._noData(),
      ],
    );
  }

  List<Widget> _noData() {
    return [
      const SizedBox(height: 120),
      Center(child: SvgPicture.asset("assets/svg/no-data.svg")),
      const SizedBox(height: 10),
      const Center(child: Text("No Data", style: MyStyles.title)),
    ];
  }
}
