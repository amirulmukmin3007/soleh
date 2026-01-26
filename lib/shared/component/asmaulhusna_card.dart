import 'package:flutter/material.dart';
import 'package:soleh/shared/component/shimmer.dart';

class AsmaUlHusnaCard2 extends StatelessWidget {
  const AsmaUlHusnaCard2({
    required this.auhMeaning,
    required this.auhAR,
    required this.auhEN,
    required this.auhNum,
    required this.dayPicture,
    this.onRefresh,
    super.key,
  });

  final String auhMeaning;
  final String auhAR;
  final String auhEN;
  final String auhNum;
  final String dayPicture;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    String getOrdinalSuffix(int number) {
      if (number < 0 || number > 99) {
        return number.toString();
      }

      int lastDigit = number % 10;

      int lastTwoDigits = number % 100;

      if (lastTwoDigits >= 11 && lastTwoDigits <= 13) {
        return '${number}th';
      }

      switch (lastDigit) {
        case 1:
          return '${number}st';
        case 2:
          return '${number}nd';
        case 3:
          return '${number}rd';
        default:
          return '${number}th';
      }
    }

    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(dayPicture),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: auhMeaning == ''
                ? const ShimmerLoad(height: 20, width: 100)
                : Text(
                    auhMeaning,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
            subtitle: auhAR == '' && auhEN == ''
                ? const ShimmerLoad(height: 10, width: 60)
                : Text(
                    '$auhAR - $auhEN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[400],
                    ),
                  ),
            trailing: auhAR == '' && auhEN == ''
                ? const ShimmerLoad(height: 10, width: 60)
                : Text(
                    '${getOrdinalSuffix(int.parse(auhNum))} name',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
