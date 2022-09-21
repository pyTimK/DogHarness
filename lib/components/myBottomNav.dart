import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _NavBarItem {
  const _NavBarItem({
    this.baseName,
    this.label,
  });

  final String? baseName;
  final String? label;
}

class MyBottomNav extends StatefulWidget {
  const MyBottomNav({required this.onPageChange, super.key});
  final ValueChanged<int> onPageChange;

  @override
  State<MyBottomNav> createState() => _MyBottomNavState();
}

class _MyBottomNavState extends State<MyBottomNav> {
  int _selectedIndex = 0;

  static const _navBarItems = <_NavBarItem>[
    _NavBarItem(
      baseName: 'home',
      label: 'Home',
    ),
    _NavBarItem(
      baseName: 'pin',
      label: 'Location',
    ),
    _NavBarItem(
      baseName: 'play-circle',
      label: 'Play',
    ),
    _NavBarItem(
      baseName: 'settings',
      label: 'Settings',
    ),
    _NavBarItem(
      baseName: 'account',
      label: 'Account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        BottomNavigationBar(
          backgroundColor: MyStyles.dark,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: MyStyles.white,
          unselectedItemColor: MyStyles.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            widget.onPageChange(index);
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems.map((navBarItem) {
            final baseName = navBarItem.baseName;
            final label = navBarItem.label;
            final type = _selectedIndex == _navBarItems.indexOf(navBarItem) ? 'filled' : 'outline';
            return BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg/$baseName-$type.svg"),
              label: label,
            );
          }).toList(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 600),
          top: 2,
          left: MediaQuery.of(context).size.width / _navBarItems.length * _selectedIndex,
          curve: const ElasticOutCurve(0.7),
          child: Container(
            width: MediaQuery.of(context).size.width / _navBarItems.length,
            height: 4,
            decoration: const BoxDecoration(
              color: MyStyles.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
        ),
      ],
    );
  }
}
