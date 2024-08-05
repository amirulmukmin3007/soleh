import 'package:flutter/material.dart';
import 'package:soleh/themes/fonts.dart';

class InfoBar extends StatelessWidget {
  const InfoBar({
    super.key,
    required this.textDisplay,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });

  final String textDisplay;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(
            255,
            200,
            200,
            200,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(
                  50,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
          ),
          Text(
            textDisplay,
            style: TextStyle(
              fontSize: 14,
              fontFamily: fontTheme.fontFamily,
              fontWeight: FontWeight.w400,
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
