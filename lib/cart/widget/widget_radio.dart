import 'package:flutter/material.dart';
class MyRadio extends StatelessWidget {
  const MyRadio({Key? key, required this.txt, required this.img}) : super(key: key);
final  String txt;
  final  String img;

  @override
  Widget build(BuildContext context) {
    return    ListTile(
      title: Row(
        children: [
          Image.asset( img ,width: 30,height: 30,),
         const SizedBox(width: 10,),
            Text(txt,
            style:const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      leading: Radio(
        value: true,
        groupValue: true,
        onChanged: (value) {},
      ),
    );
  }
}
