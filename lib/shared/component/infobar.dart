import 'package:flutter/material.dart';
import 'package:soleh/themes/colors.dart';
import 'package:soleh/themes/fonts.dart';

class InfoBar extends StatelessWidget {
  const InfoBar({
    super.key,
    required this.label,
    required this.textDisplay,
    required this.icon,
  });

  final String label;
  final String textDisplay;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: ColorTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: FontTheme().fontFamily,
                  ),
                ),
                Text(
                  textDisplay,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontTheme().fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoBarClickable extends StatefulWidget {
  const InfoBarClickable({
    Key? key,
    required this.textDisplay,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.function,
  }) : super(key: key);

  final String textDisplay;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback function;

  @override
  _InfoBarClickableState createState() => _InfoBarClickableState();
}

class _InfoBarClickableState extends State<InfoBarClickable> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped = true;
        });
      },
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _isTapped = false;
          });
          widget.function();
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_isTapped ? 0.95 : 1.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white70],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isTapped
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: widget.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8),
                  child: Text(
                    widget.textDisplay,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontTheme.fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
