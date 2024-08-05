import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleh/model/home_model.dart';
import 'package:soleh/provider/asma_ul_husna_provider.dart';
import 'package:soleh/shared/component/shimmer.dart';

class AsmaUlHusnaCard extends StatefulWidget {
  const AsmaUlHusnaCard(
      {required this.asmaUlHusnaProvider, required this.homeModel, super.key});

  final AsmaUlHusnaProvider asmaUlHusnaProvider;
  final HomeModel homeModel;

  @override
  State<AsmaUlHusnaCard> createState() => _AsmaUlHusnaCardState();
}

class _AsmaUlHusnaCardState extends State<AsmaUlHusnaCard> {
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
            image: AssetImage(
              widget.homeModel.getDayPicture(),
            ),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: widget.asmaUlHusnaProvider.meaning == ''
                ? const ShimmerLoad(height: 20, width: 100)
                : Text(
                    widget.asmaUlHusnaProvider.meaning,
                    style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
            subtitle: widget.asmaUlHusnaProvider.inArabic == '' &&
                    widget.asmaUlHusnaProvider.inEnglish == ''
                ? const ShimmerLoad(height: 10, width: 60)
                : Text(
                    '${widget.asmaUlHusnaProvider.inArabic} - ${widget.asmaUlHusnaProvider.inEnglish}',
                    style: TextStyle(
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[400],
                    ),
                  ),
            trailing: widget.asmaUlHusnaProvider.inArabic == '' &&
                    widget.asmaUlHusnaProvider.inEnglish == ''
                ? const ShimmerLoad(height: 10, width: 60)
                : Text(
                    '${widget.asmaUlHusnaProvider.number}th name',
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
