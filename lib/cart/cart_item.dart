import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/cart/cart_provider.dart';
import 'package:eradko/cart/models/cart_datals.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CartItem extends StatefulWidget {
  final Item cartItem ;
  final Function onDelete  , onQuantityUpdated;
  const CartItem({Key? key, required this.cartItem, required this.onDelete, required this.onQuantityUpdated}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int itemQuantity ;

  CartProvider cartProvider = CartProvider();

  @override
  void initState() {
    itemQuantity = widget.cartItem.quantity ;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black45,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.cartItem.productName,
                  textScaleFactor: 1.1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.price,
                          textScaleFactor: .9,
                          style: priceTextStyle(),
                        ),
                        priceSpacer(),
                        Text(AppLocalizations.of(context)!.taxFee,
                          textScaleFactor: .9,
                          style: priceTextStyle(),
                        ),
                        priceSpacer(),
                        Text(AppLocalizations.of(context)!.total,
                          textScaleFactor: .9,
                          style: priceTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cartItem.offer == 1 ?
                          (widget.cartItem.offerPrice).toString():
                          (widget.cartItem.price).toString(),
                          style: priceTextStyle(),
                          textScaleFactor: .9,
                        ),
                        priceSpacer(),
                        Text(widget.cartItem.tax.toString(),
                          style: priceTextStyle(),
                          textScaleFactor: .9,
                        ),
                        priceSpacer(),
                        Text(
                          itemQuantity == widget.cartItem.quantity ?
                          '${widget.cartItem.total} رس' : widget.cartItem.offer == 1 ?
                          (widget.cartItem.offerPrice * itemQuantity).toString():
                          '${widget.cartItem.price * itemQuantity} رس',
                          style: priceTextStyle(),
                          textScaleFactor: .9,
                        ),
                      ],
                    )
                  ],
                ),
                priceSpacer(),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 30,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove,
                                size: 15,
                                color: Colors.white,
                              ),
                              onPressed: (){
                                setState(() {
                                  if(itemQuantity > widget.cartItem.min){
                                    itemQuantity-- ;
                                  }else{
                                    showToastMag(msg:'${AppLocalizations.of(context)!.maiQuantity}: ${widget.cartItem.min}');
                                  }
                                });
                              },
                            ),
                          ),
                          Text(itemQuantity.toString(),
                            textScaleFactor: 1.1,
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.white,
                              ),
                              onPressed: (){
                                if(itemQuantity < widget.cartItem.stock ){
                                  if(itemQuantity< widget.cartItem.max){
                                    setState(() {
                                      itemQuantity++ ;
                                    });
                                  }else{
                                    showToastMag(msg: "${AppLocalizations.of(context)!.maxQuantity}: ${widget.cartItem.max} ");
                                  }
                                }else{
                                  showToastMag(msg: "${AppLocalizations.of(context)!.only}${widget.cartItem.stock}${AppLocalizations.of(context)!.available}");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    widget.cartItem.quantity == itemQuantity ? const SizedBox():
                    InkWell(
                      onTap: (){
                        widget.onQuantityUpdated(itemQuantity);
                      },
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                        child: Text(AppLocalizations.of(context)!.confirmation,

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 60,
                  width: 70,
                  child: CachedNetworkImage(
                    imageUrl: widget.cartItem.image,
                    fit: BoxFit.contain,
                    fadeInDuration: const Duration(microseconds: 200),
                    placeholder: (context, img) => categoryPlaceholder(context),
                    errorWidget: (context, image, error) {
                      return const Placeholder();
                    },
                  ),
                ),
                IconButton(
                  onPressed:(){
                    widget.onDelete() ;
                  },
                  icon: Icon(Icons.delete , color:  textColor,),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget priceSpacer() {
    return const SizedBox(height: 5);
  }
}

TextStyle priceTextStyle() {
  return const TextStyle(
      color: Colors.grey,
    fontSize: 14
);
}
