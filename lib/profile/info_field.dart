import 'package:eradko/const.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InfoField extends StatelessWidget {
  final String info ;
  const InfoField({Key? key, required this.info}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: accentColor , width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Align(
          alignment: Alignment.centerRight,
          child: info == 'null' ?
          Shimmer.fromColors(
            baseColor: textColor,
            highlightColor: Colors.white70,
            child: Text('. . . . .',
              style: TextStyle(color: textColor,fontSize: 30),
            ),
          ):
          Text(info,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
