import 'package:flutter/material.dart';
import 'package:soleh/themes/colors.dart';

Widget mainDialog(
    BuildContext context, String title, Widget content, List<Widget> actions) {
  return Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: ColorTheme.primary.withValues(alpha: 0.05),
            blurRadius: 60,
            spreadRadius: 0,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorTheme.primary,
                    ColorTheme.primary.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 15,
                      height: 1.5,
                    ),
                    child: content,
                  ),
                  const SizedBox(height: 28),
                  if (actions.isNotEmpty)
                    Row(
                      mainAxisAlignment: actions.length == 1
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.end,
                      children: [
                        for (int i = 0; i < actions.length; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Flexible(child: actions[i]),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
