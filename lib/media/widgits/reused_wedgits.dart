import 'package:eradko/const.dart';
import 'package:flutter/material.dart';

class MediaBarItem extends StatelessWidget {
  const MediaBarItem({Key? key, required this.active, required this.title})
      : super(key: key);
  final bool active;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: active ? accentColor : accentDeActive,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold,
              fontSize: 11
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
