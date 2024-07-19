import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/view/home.dart';
import 'package:soleh/view/masjid_location.dart';
import 'package:soleh/view/qibla.dart';
import 'package:soleh/view/settings.dart';

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
      bottomNavigationBar: AnimatedBottomNavigationBar(
        gapLocation: GapLocation.none,
        activeIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        icons: const [
          FluentIcons.home_24_filled,
          FluentIcons.compass_northwest_16_filled,
          FluentIcons.location_24_filled,
          FluentIcons.settings_16_filled,
        ],
        activeColor: ColorTheme.primary,
        inactiveColor: const Color.fromARGB(255, 154, 175, 156),
      ),

      // SlidingClippedNavBar(
      //   backgroundColor: Colors.white,
      //   selectedIndex: currentPageIndex,
      //   barItems: [
      //     BarItem(title: 'Home', icon: FluentIcons.home_24_filled),
      //     BarItem(title: 'Mosque', icon: FluentIcons.location_24_filled),
      //   ],
      //   onButtonPressed: (index) {
      //     setState(() {
      //       currentPageIndex = index;
      //     });
      //   },
      //   activeColor: ColorTheme.primary,
      // ),
      body: IndexedStack(index: currentPageIndex, children: const [
        Home(),
        MasjidLocation(),
        Qibla(),
        Settings(),
      ]),
    );
  }
}
