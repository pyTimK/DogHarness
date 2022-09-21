import 'package:bluetooth_app_test/components/myBottomNav.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/pages/mainPages/account.dart';
import 'package:bluetooth_app_test/pages/mainPages/home.dart';
import 'package:bluetooth_app_test/pages/mainPages/location.dart';
import 'package:bluetooth_app_test/pages/mainPages/play.dart';
import 'package:bluetooth_app_test/pages/mainPages/settings.dart';
import 'package:flutter/material.dart';

class MainPagesWrapper extends StatefulWidget {
  const MainPagesWrapper({super.key});

  @override
  State<MainPagesWrapper> createState() => _MainPagesWrapperState();
}

class _MainPagesWrapperState extends State<MainPagesWrapper> {
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
