import 'package:eradko/auth/singin.dart';
import 'package:eradko/const.dart';
import 'package:flutter/material.dart';

class NotAuthenticated extends StatelessWidget {
  const NotAuthenticated({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/image/auth.png'),
        Center(child: Text(Lang.of(context).logInFirst)),
        const SizedBox(height: 10),
        RawMaterialButton(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>const SignIn()));
          },
          shape: const StadiumBorder(),
          fillColor: accentColor,
          child: Text(
            Lang.of(context).singIn,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

showNotLoggedInDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/auth.png'),
              Center(child: Text(Lang.of(context).logInFirst)),
              const SizedBox(height: 10),
              RawMaterialButton(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const SignIn()));
                },
                shape: const StadiumBorder(),
                fillColor: accentColor,
                child: Text(
                  Lang.of(context).singIn,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
