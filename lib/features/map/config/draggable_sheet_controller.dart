import 'package:flutter/material.dart';
import 'package:soleh/shared/api/general.dart';
import 'package:url_launcher/url_launcher.dart';

class DraggableSheetConfig {
  void expandSheet(DraggableScrollableController controller) {
    controller.animateTo(
      0.4,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void collapseSheet(DraggableScrollableController controller) {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void openNavigationURL(String app, String latFrom, String longFrom,
      String latTo, String longTo) async {
    if (app == 'waze') {
      String url = wazeNavigate +
          wazeToLL +
          latTo +
          wazeToMiddle +
          longTo +
          wazeFromLL +
          latFrom +
          wazeToMiddle +
          longFrom;
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else if (app == 'googlemaps') {
      String url = "$googlemapsNavigate$latFrom,$longFrom/$latTo,$longTo";
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
