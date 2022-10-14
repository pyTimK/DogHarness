import 'package:bluetooth_app_test/components/myBottomNav.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/pages/mainPages/account.dart';
import 'package:bluetooth_app_test/pages/mainPages/home.dart';
import 'package:bluetooth_app_test/pages/mainPages/location.dart';
import 'package:bluetooth_app_test/pages/mainPages/play.dart';
import 'package:bluetooth_app_test/pages/mainPages/settings.dart';
import 'package:bluetooth_app_test/providers/bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPagesWrapper extends ConsumerStatefulWidget {
  const MainPagesWrapper({super.key});

  @override
  MainPagesWrapperState createState() => MainPagesWrapperState();
}

class MainPagesWrapperState extends ConsumerState<MainPagesWrapper> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChange(int index) {
    ref.read(isConnectAutomaticallyProvider.notifier).state = index == 2;

    setState(() {
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      bottomNavigationBar: MyBottomNav(onPageChange: _onPageChange),
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          LocationPage(),
          PlayPage(),
          SettingsPage(),
          AccountPage(),
        ],
      ),
    );
  }
}
