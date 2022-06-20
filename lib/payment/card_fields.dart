import 'package:eradko/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';


class CardNumberField extends StatefulWidget {
  const CardNumberField({
    Key? key, required this.onChanged,
  }) : super(key: key);
  final Function(String) onChanged;

  @override
  State<CardNumberField> createState() => _CardNumberFieldState();
}

class _CardNumberFieldState extends State<CardNumberField> {

  bool? isPassword  ;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric( vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: accentColor.withOpacity(.6)  , width: 1.5 ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          onChanged:  widget.onChanged,
          cursorColor: textColor,
          maxLengthEnforcement: MaxLengthEnforcement.none,
          inputFormatters: [
            CreditCardNumberInputFormatter(onCardSystemSelected:  (CardSystemData? cardSystemData) {})
          ],
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            counter: const Offstage(),
            counterText: '',
            counterStyle: const TextStyle(fontSize: 0),
            border: InputBorder.none,
            hintText: 'Card Number',
            hintStyle: TextStyle(
              color: textColor.withOpacity(.6),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CVVAndExpirationDate extends StatelessWidget {
  final Function(String) date , cvv;
  const CVVAndExpirationDate({Key? key, required this.date, required this.cvv}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric( vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: accentColor.withOpacity(.6)  , width: 1.5 ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: date,
                cursorColor: textColor,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                inputFormatters: [
                  CreditCardExpirationDateFormatter()
                ],
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'MM/YY',
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(.6),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: VerticalDivider(
                  color: accentColor.withOpacity(.6)  , width: 2,
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: cvv,
                cursorColor: textColor,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                inputFormatters: [
                  CreditCardCvcInputFormatter()
                ],
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'CVV',
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(.6),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


