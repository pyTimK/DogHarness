import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_app_test/components/myText.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/providers/bluetooth.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> with AutomaticKeepAliveClientMixin<SettingsPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const PageScrollLayout(
      padding: EdgeInsets.symmetric(horizontal: 20),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        MyText.h1("Settings"),
        SizedBox(height: 35),
        _BluetoothSection(),
        SizedBox(height: 50),
        _AboutSection(),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/about"),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          MyText.h2("About"),
          Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _BluetoothSection extends StatelessWidget {
  const _BluetoothSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Section(title: "Bluetooth", children: [
      _BluetoothSettingsTile(),
    ]);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, super.key});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.h2(title),
        const SizedBox(height: 15),
        ...children,
      ],
    );
  }
}

class _BluetoothSettingsTile extends ConsumerStatefulWidget {
  const _BluetoothSettingsTile({super.key});

  @override
  __BluetoothSettingsTileState createState() => __BluetoothSettingsTileState();
}

class __BluetoothSettingsTileState extends ConsumerState<_BluetoothSettingsTile> {
  bool justPressed = false;

  void onChanged(bool isConnected) async {
    logger.e("PRESSED: $justPressed");
    if (justPressed) return;

    setState(() {
      justPressed = true;
    });

    // TODO: implement toggle bluetooth
    logger.wtf("newValue ${isConnected}");
    if (isConnected) {
      await ref.read(connectedDeviceProvider.notifier).connect();
    } else {
      await ref.read(connectedDeviceProvider.notifier).disconnect();
    }
    setState(() {
      justPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bluetoothState = ref.watch(bluetoothStateProvider).value;
    bool bluetoothOn = bluetoothState == BluetoothState.on;
    var connectedDevice = ref.watch(connectedDeviceProvider).value;

    return _SettingsTile.toggle(
      label: Constants.deviceName,
      icon: const Icon(Icons.bluetooth_rounded, size: 25, color: MyStyles.dark),
      value: connectedDevice != null,
      onChanged: bluetoothOn ? onChanged : (newVal) => AppSettings.openBluetoothSettings(),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  _SettingsTile.toggle(
      {required this.label, this.icon, required bool value, required void Function(bool)? onChanged, super.key})
      : trailing = Switch(
          value: value,
          onChanged: onChanged,
        );

  final Widget? icon;
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [icon ?? const SizedBox.shrink(), MyText.h2Regular(label)],
        ),
        trailing,
      ],
    );
  }
}
