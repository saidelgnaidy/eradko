import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String txt;
  const Header({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80, bottom: 30),
          child: SizedBox(
            height: 130,
            child: Center(
              child: Image.asset("assets/image/logo.png"),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 15 ),
            child: Text(txt,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
