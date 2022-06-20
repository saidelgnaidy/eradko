// ignore_for_file: avoid_print, prefer_const_constructors, deprecated_member_use

import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/const.dart';
import 'package:eradko/payment/card_fields.dart';
import 'package:eradko/payment/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:provider/provider.dart';




class DirectPayment extends StatefulWidget {
  final String totalAmount ;
  final int methodId ;
  const DirectPayment({Key? key,required this.totalAmount,required this.methodId}) : super(key: key);

  @override
  _DirectPaymentState createState() => _DirectPaymentState();
}

class _DirectPaymentState extends State<DirectPayment> {

  // test card 5453010000095489  Mahmoud Ibrahim  05/21   100
  String cardNumber = "5453010000095489";
  String expiryMonth = "5";
  String expiryYear = "21";
  String securityCode = "100";
  String cardHolderName = "Mahmoud Ibrahim";


  @override
  void initState() {
    super.initState();
  }

  void pay({required PaymentProvider paymentProvider }) {
    if (cardNumber.isEmpty || expiryMonth.isEmpty || expiryYear.isEmpty || securityCode.isEmpty || cardHolderName.isEmpty) {
      showSnackError(context, msg: 'Fill all the card fields');
    } else {
      MFCardInfo mfCardInfo =  MFCardInfo(cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, securityCode: securityCode,
        cardHolderName: cardHolderName, bypass3DS: false, saveToken: false,);
      paymentProvider.executeDirectPayment(mfCardInfo: mfCardInfo , paymentMethodId: widget.methodId ,
          amount: double.parse(widget.totalAmount) ,context: context,addressId: paymentProvider.selectedAddress! , locale: Lang.of(context).localeName ,);
    }
  }





  @override
  Widget build(BuildContext context) {
    final PaymentProvider  paymentProvider = Provider.of<PaymentProvider>(context) ;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: CustomTextField(
              hintText: 'Name on Card',
              onChanged: (val){
                cardHolderName = val ;
              },
              obscureText: false,
            ),
          ),
          CardNumberField(
            onChanged: (cardNum){
              cardNumber = cardNum.replaceAll(' ', '') ;
            },
          ),
          CVVAndExpirationDate(
            cvv: (cvv){
              securityCode = cvv ;
            },
            date: (date){
              expiryMonth =  date.split('/').first;
              expiryYear =  date.split('/').last;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric( vertical: 5),
            child: SizedBox(
              height: 50,
              child: RawMaterialButton(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
                onPressed: (cardNumber.isEmpty || expiryMonth.isEmpty || expiryYear.isEmpty || securityCode.isEmpty || cardHolderName.isEmpty) ? null :() {
                  pay(paymentProvider: paymentProvider);
                },
                fillColor: accentColor,
                child: Text('Pay' , style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Center(child: Text(paymentProvider.paymentErrorMag ,style: TextStyle(color: textColor),))
        ],
      ),
    );
  }


}