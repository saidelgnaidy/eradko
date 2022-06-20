import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferBadge extends StatelessWidget {
  const OfferBadge({
    Key? key, required this.offerPercent,
  }) : super(key: key);
  final double offerPercent  ;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(8) , bottomLeft: Radius.circular(8)),
            color: Colors.red
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${offerPercent.ceil()} %' ,
              style: GoogleFonts.roboto(
                  color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
