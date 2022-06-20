// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/cart/cart_provider.dart';
import 'package:eradko/category_page_view/models/product_model.dart';
import 'package:eradko/category_page_view/products_provider.dart';
import 'package:eradko/commercial_id/commercial_id.dart';
import 'package:eradko/commercial_id/user_cmmercial_provider.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/const.dart';
import 'package:eradko/favorites/favorite_provider.dart';
import 'package:eradko/home/page_indcator.dart';
import 'package:eradko/profile/empty_profile.dart';
import 'package:flutter/material.dart';
import 'offers/offer_badge.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _controller = PageController();
  late Product product ;
  bool loading = true ;
  final CartProvider cartProvider = CartProvider();
  final FavoriteProvider favoriteProvider = FavoriteProvider();

  late bool isFavorite=false;
  bool isAdding = false;

  final ProductsProvider _productsProvider = ProductsProvider();

  launch(url) async {
    if (!await launchUrl(url)) {
      throw AppLocalizations.of(context)!.notLaunch;
    }
  }

  visitWepSite() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.vistLink,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () async {
              if (!await launch('https://eradunited.com')) {
                throw AppLocalizations.of(context)!.notLaunch;
              }
            },
            child: Text(
              "www.eradco.com",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  showDescription({required BuildContext context, required String description}) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              description,
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }


  addItemToCart(BuildContext context) {
    setState(() => isAdding = true);
    cartProvider.addToCart(productId: product.id, quantity: product.stock < product.min ? product.stock : product.min).then((value) {
      setState(() => isAdding = false);
      if(value){
        showToastMag(msg:AppLocalizations.of(context)!.addedToCart );
      }else{
        showToastMag(msg:AppLocalizations.of(context)!.conectApp);
      }
    });
  }




  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async =>
    _productsProvider.getProductDetails(id: widget.id, locale:AppLocalizations.of(context)!.localeName).then((value){
      if(mounted){
        setState(() {
          product = value ;
          loading = false ;
        });
      }
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favorite = Provider.of<FavoriteProvider>(context);
    AuthProvider auth = Provider.of<AuthProvider>(context);
    final UserCommercialProvider user = Provider.of<UserCommercialProvider>(context);

    return Scaffold(
      appBar: buildAppBar(context, showCart: true,needPop: true),
      body: loading ? Center(
        child: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation(accentColor),
          backgroundColor: Colors.white,
        ),
      ):
      product.id == 0 ?
      SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.conectApp,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ):
      SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 70,top: 10),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: product.gallery.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: product.gallery[index].image,
                        fit: BoxFit.contain,
                        fadeInDuration: Duration(microseconds: 200),
                        placeholder: (context, img) => categoryPlaceholder(context),
                        errorWidget: (context, image, error) {
                          return Placeholder();
                        },
                      );
                    },
                  ),
                  Positioned(
                    bottom: -30,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: DotsIndicator(
                          controller: _controller,
                          itemCount: product.gallery.length,
                          onPageSelected: (int page) {
                            _controller.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.ease,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: (){
                        if(auth.token == 'null'){
                          showNotLoggedInDialog(context);
                        }else{
                          setState(() {
                            isFavorite = true ;
                            favorite.addToFavorite(productId: product.id).then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!.addToFavo,
                                  textAlign: TextAlign.center,
                                ),
                                duration: Duration(seconds: 2),
                              ));
                            });
                          });
                        }
                      },
                      icon: Icon( isFavorite ? Icons.favorite : Icons.favorite_border, size: 35,color:  Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 10),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  product.offerPercentage.toDouble() == 0.0 ?
                  Text(
                    "${product.price} SAR",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ) :
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Text(
                              "${product.offerPrice} SAR",
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 20),
                            OfferBadge(
                              offerPercent: product.offerPercentage,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${product.price} SAR",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    children: [
                      product.securityClearance?
                      FittedBox(child: ProductNote(note: AppLocalizations.of(context)!.addCommercial)):SizedBox(),
                      product.sellingAt == 'branches' ?
                      FittedBox(child: ProductNote(note: AppLocalizations.of(context)!.payFromOnly)) :
                      SizedBox(),
                      product.properties != [] ?
                      Wrap(
                        children: product.properties!.map((property) {
                          return ProductNote(note: '${property.titleAr} : ${property.valueAr}');
                        }).toList(),
                      ):
                      SizedBox(),
                      product.stock > 0 ?
                      FittedBox(child: ProductNote(note: '${AppLocalizations.of(context)!.inStock}${product.stock}')) :
                      FittedBox(child: ProductNote(note:AppLocalizations.of(context)!.notAvilabal)),
                      FittedBox(child: ProductNote(note: '${AppLocalizations.of(context)!.minOrder} ${product.min}')),
                      FittedBox(child: ProductNote(note: '${AppLocalizations.of(context)!.maxOrder} ${product.max}')),
                    ],
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    children: [
                      product.videoLink == '' ?
                      SizedBox() :
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: AttachmentsBtn(
                          onTap: () {
                            launch(product.videoLink);
                          },
                          icon: FontAwesomeIcons.play,
                          title:AppLocalizations.of(context)!.video,
                        ),
                      ),
                      product.productAttachments != [] ?
                      Wrap(
                        children: product.productAttachments.map((attach) {
                          return AttachmentsBtn(
                            title: AppLocalizations.of(context)!.downloadPDF,
                            icon: FontAwesomeIcons.download,
                            onTap: (){
                              launch(attach.file);
                            },
                          );
                        }).toList(),
                      ) :
                      SizedBox(),
                      visitWepSite(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: loading ?
      SizedBox() :
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            color: Colors.green,
            height: 50,
            minWidth: MediaQuery.of(context).size.width,
            child: Text(
              AppLocalizations.of(context)!.aboutProduct,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              showDescription(context: context, description: product.description);
            },
          ),
          MaterialButton(
            color: Colors.amber,
            height: 50,
            minWidth: MediaQuery.of(context).size.width,
            child:
            isAdding?
            Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )):
            Text(
              AppLocalizations.of(context)!.addToCart,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              if(auth.token == 'null'){
                showNotLoggedInDialog(context);
              }else{
                if(product.securityClearance){
                  if (user.userInfo.hasCommercial){
                    addItemToCart(context);
                  }else{
                    showNeedCommercialDialog(context);
                  }
                }else{
                  addItemToCart(context);
                }
              }
            },
          ),
        ],
      ),
      floatingActionButtonLocation: AppLocalizations.of(context)!.localeName =='ar' ?
      FloatingActionButtonLocation.startFloat :
      FloatingActionButtonLocation.endFloat ,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        backgroundColor: accentColor,
        child: Icon(AppLocalizations.of(context)!.localeName =='ar' ? Icons.arrow_back : Icons.arrow_forward , color: Colors.white,),
      ),
    );
  }
}



class AttachmentsBtn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;

  const AttachmentsBtn({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FittedBox(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.green),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.green,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(width: 10),
              Icon(
                icon,
                size: 15,
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductNote extends StatelessWidget {
  const ProductNote({
    Key? key,
    required this.note,
  }) : super(key: key);
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.only(left: 5, bottom: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Text(note,
        style: GoogleFonts.tajawal(
          color: textColor,
          fontSize: 13
        ),
      ),
    );
  }
}
