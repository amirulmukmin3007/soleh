import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:soleh/features/home/screens/home.dart';
import 'package:soleh/features/map/screens/map.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/features/qibla/screens/qibla.dart';
import 'package:soleh/features/calendar/screens/calendar.dart';
import 'package:soleh/view/settings.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key});

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  List<bool> pageFlags = [true, false, false, false, false];

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  final List<NavItem> _navItems = [
    NavItem(
      icon: FluentIcons.home_24_regular,
      activeIcon: FluentIcons.home_24_filled,
      label: 'Home',
    ),
    NavItem(
      icon: FluentIcons.compass_northwest_16_regular,
      activeIcon: FluentIcons.compass_northwest_16_filled,
      label: 'Qibla',
    ),
    NavItem(
      icon: FluentIcons.location_24_regular,
      activeIcon: FluentIcons.location_24_filled,
      label: 'Map',
    ),
    NavItem(
      icon: FluentIcons.calendar_12_regular,
      activeIcon: FluentIcons.calendar_12_filled,
      label: 'Calendar',
    ),
    NavItem(
      icon: FluentIcons.settings_16_regular,
      activeIcon: FluentIcons.settings_16_filled,
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 350),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutQuad,
      );
    }).toList();

    _controllers[0].value = 1.0;
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (currentPageIndex == index) return;

    setState(() {
      _controllers[currentPageIndex].reverse();
      _controllers[index].forward();
      currentPageIndex = index;

      for (int i = 0; i < pageFlags.length; i++) {
        pageFlags[i] = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_navItems.length, (index) {
                return _buildNavItem(index);
              }),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          HomeScreen(),
          QiblaScreen(isActive: pageFlags[1]),
          MapScreen(isActive: pageFlags[2]),
          CalendarPage(),
          Settings(isActive: pageFlags[4]),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final navItem = _navItems[index];

    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final indicatorSize = 24.0 + (12.0 * _animations[index].value);

            return SizedBox(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _animations[index].value,
                        child: Container(
                          width: indicatorSize,
                          height: indicatorSize,
                          decoration: BoxDecoration(
                            color: ColorTheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Icon(
                        _animations[index].value > 0.5
                            ? navItem.activeIcon
                            : navItem.icon,
                        size: 24,
                        color: ColorLerp.lerp(
                          const Color.fromARGB(255, 154, 175, 156),
                          ColorTheme.primary,
                          _animations[index].value,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _animations[index].value,
                    child: Text(
                      navItem.label,
                      style: TextStyle(
                        color: ColorTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class ColorLerp {
  static Color lerp(Color a, Color b, double t) {
    return Color.fromARGB(
      lerpInt((a.a * 255.0).round().clamp(0, 255),
          (b.a * 255.0).round().clamp(0, 255), t),
      lerpInt((a.r * 255.0).round().clamp(0, 255),
          (b.r * 255.0).round().clamp(0, 255), t),
      lerpInt((a.g * 255.0).round().clamp(0, 255),
          (b.g * 255.0).round().clamp(0, 255), t),
      lerpInt((a.b * 255.0).round().clamp(0, 255),
          (b.b * 255.0).round().clamp(0, 255), t),
    );
  }

  static int lerpInt(int a, int b, double t) {
    return (a + (b - a) * t).round();
  }
}
