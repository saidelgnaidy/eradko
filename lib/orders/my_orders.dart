import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/const.dart';
import 'package:eradko/orders/order_details.dart';
import 'package:eradko/orders/orders_list_model.dart';
import 'package:eradko/orders/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  GetOrdersList ordersList = GetOrdersList(data: []) ;
  bool loading = true ;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)=> OrdersProvider().getOrdersList(locale: Lang.of(context).localeName).then((value){
      if(mounted){
        setState(() {
          ordersList = value ;
          loading = false ;
        });
      }
    }) );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const Center(child: LinearProgressIndicator()) :
    ListView.builder(
      itemCount: ordersList.data.length,
      itemBuilder: (context , index) {
        return  ExpansionTile(
          trailing: Text(ordersList.data[index].date ,
            style: GoogleFonts.roboto(
              color: accentDeActive,
              fontWeight: FontWeight.bold ,
              fontSize: 11,
            ),
          ),
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text( AppLocalizations.of(context)!.orderNumber ,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold ,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(ordersList.data[index].receipt ,
                  style: GoogleFonts.roboto(
                    color: accentColor,
                    fontWeight: FontWeight.bold ,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 35,
                    child: RawMaterialButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(id: ordersList.data[index].id )),);
                      },
                      fillColor: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Text(AppLocalizations.of(context)!.orderDetails,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: RawMaterialButton(
                      onPressed: (){

                      },
                      fillColor: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Text(AppLocalizations.of(context)!.followOrder,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: RawMaterialButton(
                      onPressed: (){
                        OrdersProvider().cancelOrder( id: ordersList.data[index].id).then((value) {
                          showSnackError(context, msg: value);
                        });
                      },
                      fillColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Text(AppLocalizations.of(context)!.cancelOrder,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ) ;
      },
    );
  }
}

