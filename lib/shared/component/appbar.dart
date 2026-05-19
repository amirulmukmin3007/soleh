import 'package:flutter/material.dart';
import 'package:soleh/themes/colors.dart';

// ignore: must_be_immutable
class CalendarAppBar extends StatefulWidget implements PreferredSizeWidget {
  CalendarAppBar({super.key, required this.isYearView});

  bool isYearView;

  @override
  State<CalendarAppBar> createState() => _CalendarAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CalendarAppBarState extends State<CalendarAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Calendar'),
      backgroundColor: ColorTheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Toggle between year view and month view
        IconButton(
          icon: Icon(widget.isYearView
              ? Icons.calendar_month
              : Icons.calendar_view_month),
          onPressed: () {
            setState(() {
              widget.isYearView = !widget.isYearView;
            });
          },
          tooltip: widget.isYearView ? 'Month View' : 'Year View',
        ),
      ],
    );
  }
}
