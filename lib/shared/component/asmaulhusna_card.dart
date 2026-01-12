import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                      fontFamily: GoogleFonts.lato().fontFamily,
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
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[400],
                    ),
                  ),
            trailing: auhAR == '' && auhEN == ''
                ? const ShimmerLoad(height: 10, width: 60)
                : Text(
                    '${auhNum}th name',
                    style: TextStyle(
                      fontFamily: GoogleFonts.montserrat().fontFamily,
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
