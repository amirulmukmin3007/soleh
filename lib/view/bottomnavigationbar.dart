import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/view/home.dart';
import 'package:soleh/view/map.dart';
import 'package:soleh/view/qibla.dart';
import 'package:soleh/view/settings.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key});

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  int currentPageIndex = 0;
  List<bool> pageFlags = [true, false, false, false];

  void ifActive(int index) {
    setState(() {
      for (int i = 0; i < pageFlags.length; i++) {
        pageFlags[i] = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0),
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: (index) {
            setState(() {
              currentPageIndex = index;
              ifActive(index);
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FluentIcons.home_24_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FluentIcons.compass_northwest_16_filled),
              label: 'Qibla',
            ),
            BottomNavigationBarItem(
              icon: Icon(FluentIcons.location_24_filled),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(FluentIcons.settings_16_filled),
              label: 'Settings',
            ),
          ],
          selectedItemColor: ColorTheme.primary,
          unselectedItemColor: const Color.fromARGB(255, 154, 175, 156),
        ),
      ),
      body: IndexedStack(index: currentPageIndex, children: [
        Home(isActive: pageFlags[0]),
        Qibla(isActive: pageFlags[1]),
        MosqueMap(isActive: pageFlags[2]),
        Settings(isActive: pageFlags[3]),
      ]),
    );
  }
}
