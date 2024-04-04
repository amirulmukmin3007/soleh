import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/view/home.dart';
import 'package:soleh/view/masjid_location.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key});

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        selectedIndex: currentPageIndex,
        barItems: [
          BarItem(title: 'Home', icon: FluentIcons.home_24_filled),
          BarItem(title: 'Mosque', icon: FluentIcons.location_24_filled),
        ],
        onButtonPressed: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        activeColor: ColorTheme.primary,
      ),
      body: IndexedStack(index: currentPageIndex, children: [
        Home(),
        MasjidLocation(),
      ]),
    );
  }
}
