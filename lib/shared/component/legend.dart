import 'package:flutter/material.dart';
import 'package:soleh/themes/fonts.dart';

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    final FontTheme fontTheme = FontTheme();

    return Column(
      children: [
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Text(
              'Rangkaian Pakej',
              style: TextStyle(
                  fontFamily: fontTheme.fontFamily,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/drop-off-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Drop-Off',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/pick-up-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Pick-Up',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/pick-up-drop-off-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Pick-Up & Drop-Off',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/return-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Return',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Text(
              'Postal',
              style: TextStyle(
                  fontFamily: fontTheme.fontFamily,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/ezi-box-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'EziBox',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/ezi-drive-thru-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'EziDrive-Thru',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/ezi-drop-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'EziDrop',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/pejabat-pos-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Pejabat Pos',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/pos-laju-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Pos Laju',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/pos-mini-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Pos Mini',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/posmen-komuniti-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Posmen Komuniti',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Text(
              'Courier',
              style: TextStyle(
                  fontFamily: fontTheme.fontFamily,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/affiliate-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Affiliate',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/agent-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Agent',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/branch-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Branch',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/drive-thru-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Drive-Thru',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/franchise-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Franchise',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/kiosk-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Kiosk',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/office-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Office',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/parcel-locker-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Parcel Locker',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/public/markers/pejabat-pos-marker.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Service Center',
              style: TextStyle(
                fontFamily: fontTheme.fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
