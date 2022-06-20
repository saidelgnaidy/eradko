import 'package:flutter/material.dart';

showSnackError(BuildContext context, {required String msg}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(msg),
        ],
      ),
      backgroundColor: Colors.red,
    ),
  );
}