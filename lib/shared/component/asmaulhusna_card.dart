import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/model/home_model.dart';
import 'package:soleh/shared/component/shimmer.dart';

class AsmaUlHusnaCard extends StatefulWidget {
  const AsmaUlHusnaCard({required this.homeModel, super.key});

  final HomeModel homeModel;

  @override
  State<AsmaUlHusnaCard> createState() => _AsmaUlHusnaCardState();
}

class _AsmaUlHusnaCardState extends State<AsmaUlHusnaCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8.0,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.homeModel.getDayPicture(),
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.5),
              ),
            ),
            ListTile(
              title: widget.homeModel.auhMeaning == ''
                  ? const ShimmerLoad(height: 20, width: 100)
                  : Text(
                      widget.homeModel.auhMeaning,
                      style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              subtitle:
                  widget.homeModel.auhAR == '' && widget.homeModel.auhEN == ''
                      ? const ShimmerLoad(height: 10, width: 60)
                      : Text(
                          '${widget.homeModel.auhAR} - ${widget.homeModel.auhEN}',
                          style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[400],
                          ),
                        ),
              trailing:
                  widget.homeModel.auhAR == '' && widget.homeModel.auhEN == ''
                      ? const ShimmerLoad(height: 10, width: 60)
                      : Text(
                          '${widget.homeModel.auhNum}th name',
                          style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}
