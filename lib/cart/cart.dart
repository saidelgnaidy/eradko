import 'package:eradko/cart/cart_provider.dart';
import 'package:eradko/cart/models/cart_datals.dart';
import 'package:eradko/cart/cart_item.dart';
import 'package:eradko/category_page_view/product_details.dart';
import 'package:eradko/common/app_drawer.dart';
import 'package:eradko/const.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:eradko/payment/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartProvider cartProvider = CartProvider();
  late CartDetails _cartDetails = CartDetails(id: 0, userId: 0, subtotal: 0.0, tax: 0.0, total: 0.0, items: []);
  bool loading = true ;
  late bool cartResponseState ;
  String errorDetails = '' ;

  getCartDetails() {
    cartProvider.getCartData().then((cartMap) {
      if(cartMap['status']){
        if(mounted){
          setState(() {
            _cartDetails = cartMap['data'];
            loading = false ;
            cartResponseState = true ;
          });
        }
      }else{
        if(cartMap['data'] == 'SocketException'){
          if(mounted){
            setState(() {
              loading = false ;
              cartResponseState = false ;
              errorDetails = AppLocalizations.of(context)!.conectApp;
            });
          }
        } else {
          if(mounted){
            setState(() {
              loading = false ;
              cartResponseState = false ;
              errorDetails = AppLocalizations.of(context)!.cartEmpty;
            });
          }
        }
      }
    });
  }


  @override
  void initState() {
    getCartDetails() ;
    super.initState();
  }

  deleteCartItem(BuildContext context , {required int inCartId }) {
    cartProvider.deleteItem(productIdInCart: inCartId).then((value) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if(value['state']){
        _cartDetails = value['data'];
        if(mounted) setState(() {});
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value['msg'],
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
      ));
    });
  }

  updateItemQuantity(BuildContext context , {required int inCartId , required int quantity }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!.loading,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 5),
    ));
    cartProvider.updateItemQuantity(productIdInCart: inCartId, quantity: quantity).then((value) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if(value['state']){
        _cartDetails = value['data'];
        setState(() {});
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value['msg'],
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
      ));
    });
  }




  @override
  Widget build(BuildContext context) {
    final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context);

    return  WillPopScope(
      onWillPop: () async {
        routsProvider.topLayerSetter(widget: const SizedBox(), index: routsProvider.previousIndex == routsProvider.topWidgetIndex ? routsProvider.lastNavIndex : routsProvider.previousIndex,
            previousIndex: routsProvider.previousIndex == routsProvider.topWidgetIndex ? 0 : routsProvider.previousIndex);
        return false ;
      },
      child: Scaffold(
          drawer: const MyDrawer(),
          appBar: routsProvider.topWidget.toString() == const Cart().toString() ? null :PreferredSize(
            preferredSize: const Size(0, 55),
            child: AppBar(
              backgroundColor: const Color(0xff0e9e59),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(top: 7.5),
                child: SizedBox(
                  height: 40,
                  child: Image.asset(
                    'assets/image/logoerad.png',
                  ),
                ),
              ),
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(AppLocalizations.of(context)!.localeName =='ar' ? Icons.arrow_back : Icons.arrow_forward),
              ),
            ),
          ),
          body: loading ?
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(accentColor),
            backgroundColor: Colors.white,
          ) : cartResponseState ? _cartDetails.items.isEmpty ?
          Center(
            child: Text(AppLocalizations.of(context)!.cartEmpty),
          ):
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _cartDetails.items.length ,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(id: _cartDetails.items[index].productId)));
                      },
                      child: CartItem(
                        cartItem: _cartDetails.items[index] ,
                        onDelete: (){
                          deleteCartItem(context , inCartId: _cartDetails.items[index].id);
                          setState(() {
                            _cartDetails.items.removeAt(index);
                          });
                        },
                        onQuantityUpdated: (quantity){
                          updateItemQuantity(context, inCartId: _cartDetails.items[index].id, quantity: quantity);
                        },
                      ),
                    );
                  },
                ),
              ),
              _cartDetails.items.isEmpty ? const SizedBox():
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 5,left: 20,right: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12 , width: 1),
                  color: Colors.white
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(AppLocalizations.of(context)!.subtotal,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         Text("${_cartDetails.subtotal} SAR",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(AppLocalizations.of(context)!.taxFee,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("${_cartDetails.tax} SAR",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.total,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("${_cartDetails.total} SAR",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ):
          Center(
            child: Text(errorDetails
            ),
          ),
          bottomNavigationBar: loading ?
          const SizedBox(): cartResponseState ? _cartDetails.items.isEmpty ?
          const SizedBox():
          SizedBox(
            height: 60,
            child: Container(
              color: Colors.green,
              child: MaterialButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  Checkout(cartDetails: _cartDetails),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:   Text(AppLocalizations.of(context)!.conOrder,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Text('${_cartDetails.total}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ):
          const SizedBox(),

      ),
    );
  }
}
