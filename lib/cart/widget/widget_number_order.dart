import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class NumberOrder extends StatelessWidget {
  const NumberOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    Padding(
      padding: const EdgeInsets.only(
        right: 20,
        left: 20,
        top: 0,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.green),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:   [
              Text(
                AppLocalizations.of(context)!.orderNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                " 12345687954  ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
