// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/cart/cart_provider.dart';
import 'package:eradko/commercial_id/commercial_id.dart';
import 'package:eradko/commercial_id/user_cmmercial_provider.dart';
import 'package:eradko/const.dart';
import 'package:eradko/profile/empty_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'models/product_model.dart';
import 'offers/offer_badge.dart';
import 'package:provider/provider.dart';

class ProductTileInfo extends StatefulWidget {
  final ProductTileDetails product;
  const ProductTileInfo({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductTileInfo> createState() => _ProductTileInfoState();
}

class _ProductTileInfoState extends State<ProductTileInfo> {
  final CartProvider cartProvider = CartProvider();
  bool isAdding = false;
  addItemToCart(BuildContext context) {
    setState(() => isAdding = true);
    cartProvider
        .addToCart(productId: widget.product.id, quantity: widget.product.stock < widget.product.min ? widget.product.stock : widget.product.min)
        .then((value) {
      setState(() => isAdding = false);
      if (value) {
        showToastMag(msg: AppLocalizations.of(context)!.addedToCart);
      } else {
        showToastMag(msg: AppLocalizations.of(context)!.conectApp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    final UserCommercialProvider user = Provider.of<UserCommercialProvider>(context);

    return Stack(
      children: [
        Container(
          width: size.width / 2,
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1.0,
                color: Color(0xffE5E5E5),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.width * .3,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.image,
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(microseconds: 200),
                    placeholder: (context, img) => categoryPlaceholder(context),
                    errorWidget: (context, image, error) {
                      return Placeholder();
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff6D6D6D),
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * .11,
                      height: size.width * .11,
                      child: RawMaterialButton(
                        onPressed: () {
                          if (auth.token == 'null') {
                            showNotLoggedInDialog(context);
                          } else {
                            if (widget.product.securityClearance) {
                              if (user.userInfo.hasCommercial) {
                                addItemToCart(context);
                              } else {
                                showNeedCommercialDialog(context);
                              }
                            } else {
                              addItemToCart(context);
                            }
                          }
                        },
                        elevation: 0,
                        fillColor: Color(0xffEF8A16),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: isAdding
                            ? Center(
                                child: SizedBox(
                                width: size.width * .05,
                                height: size.width * .05,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              ))
                            : Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: widget.product.offerPercentage!.toDouble() == 0.0
                          ? Text(
                              '${widget.product.price}   SAR',
                              style: GoogleFonts.lato(
                                fontSize: size.width * .034,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff414141),
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  '${widget.product.offerPrice}   SAR',
                                  style: GoogleFonts.lato(
                                    fontSize: size.width * .034,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff414141),
                                  ),
                                ),
                                Text(
                                  '${widget.product.price}   SAR',
                                  style: GoogleFonts.lato(
                                    fontSize: size.width * .028,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        widget.product.offerPercentage == 0.0
            ? SizedBox()
            : Positioned(
                top: 6,
                right: 6,
                child: OfferBadge(
                  offerPercent: widget.product.offerPercentage!.toDouble(),
                ),
              ),
      ],
    );
  }
}
