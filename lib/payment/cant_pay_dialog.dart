



import 'package:eradko/const.dart';
import 'package:flutter/material.dart';

showCantPayDialog({required BuildContext context  , required String message }){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Center(child: Text(Lang.of(context).failedToPay , style: TextStyle(color: textColor ),)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/image/failedtopay.png' , width: MediaQuery.of(context).size.width/2.5 , height: MediaQuery.of(context).size.width/2.5,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(message ,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                  color: Colors.red ,fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}