import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myDogDropdown.dart';
import 'package:bluetooth_app_test/components/myText.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/providers/bluetooth.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PlayPage extends ConsumerStatefulWidget {
  const PlayPage({super.key});

  @override
  PlayPageState createState() => PlayPageState();
}

class PlayPageState extends ConsumerState<PlayPage> with AutomaticKeepAliveClientMixin<PlayPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var bluetoothState = ref.watch(bluetoothStateProvider).value;
    var bluetoothData = ref.watch(connectedDeviceProvider).value;
    var walkingDog = ref.watch(walkingDogProvider);
    logger.e(bluetoothData);

    bool isBluetoothOff = bluetoothState != BluetoothState.on;

    if (isBluetoothOff) return const _BluetoothDisabled();
    if (bluetoothData == null) return const _FindingDevice();
    if (walkingDog == null) return const _SelectWalkingDog();
    return const MyText("WAAAAAAAAAAAAAAAAAAAAAAAA");
  }
}

class _SelectWalkingDog extends ConsumerStatefulWidget {
  const _SelectWalkingDog({super.key});

  @override
  _SelectWalkingDogState createState() => _SelectWalkingDogState();
}

class _SelectWalkingDogState extends ConsumerState<_SelectWalkingDog> {
  final _dropdownController = MyDogDropdownController();

  void selectWalkingDog() {
    ref.read(walkingDogProvider.notifier).state = _dropdownController.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MyText.h1("Who will you walk today?"),
            const SizedBox(height: 40),
            MyDogDropdown(controller: _dropdownController),
            const SizedBox(height: 200),
            MyButton(
              label: "CONTINUE",
              onPressed: selectWalkingDog,
            ),
          ],
        ),
      ),
    );
  }
}

class _BluetoothDisabled extends StatelessWidget {
  const _BluetoothDisabled({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MyText.h1("Bluetooth disabled"),
          const SizedBox(height: 25),
          SvgPicture.asset("assets/svg/dog-crying.svg"),
          const SizedBox(height: 25),
          const MyText.p("Please turn on bluetooth to continue"),
          const SizedBox(height: 25),
          const MyButton.shrink(
            label: "Turn On",
            onPressed: AppSettings.openBluetoothSettings,
          ),
        ],
      ),
    );
  }
}

class _FindingDevice extends ConsumerStatefulWidget {
  const _FindingDevice({super.key});

  @override
  _FindingDeviceState createState() => _FindingDeviceState();
}

class _FindingDeviceState extends ConsumerState<_FindingDevice> {
  @override
  void initState() {
    super.initState();
    connect();
  }

  Future<void> connect() async {
    await ref.read(connectedDeviceProvider.notifier).connect();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // SvgPicture.asset("assets/svg/bluetooth-circle.svg"),

          AvatarGlow(
            glowColor: MyStyles.dark,
            endRadius: 130.0,
            child: CircleAvatar(
              radius: 73,
              backgroundColor: MyStyles.dark,
              child: Icon(Icons.bluetooth_rounded, size: 100, color: MyStyles.white),
            ),
          ),
          SizedBox(height: 10),
          MyText.h1("Finding your device"),
          SizedBox(height: 10),
          MyText.p("Please make sure that the device is already turned on"),
        ],
      ),
    );
  }
}
