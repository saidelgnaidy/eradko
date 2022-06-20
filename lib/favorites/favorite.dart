import 'package:eradko/category_page_view/models/product_model.dart';
import 'package:eradko/category_page_view/product_details.dart';
import 'package:eradko/common/app_drawer.dart';
import 'package:eradko/const.dart';
import 'package:eradko/favorites/favorite_provider.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  late final ProductTileDetails product;
  @override
  Widget build(BuildContext context) {
    FavoriteProvider favorite = Provider.of<FavoriteProvider>(context);
    final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context , listen: false);

    return WillPopScope(
      onWillPop: () async {
        routsProvider.topLayerSetter(widget: const SizedBox(), index: routsProvider.previousIndex ,
            previousIndex: routsProvider.previousIndex );
        return false ;
      },
      child: Scaffold(
        drawer: const MyDrawer(),
        body: FutureBuilder(
          future: favorite.getFavorite(locale: AppLocalizations.of(context)!.localeName),
          builder: (context, snapshot) {
            if (!snapshot.hasData && favorite.favoriteListGitter.isEmpty) {
             return LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(accentColor),
                backgroundColor: Colors.white,
              );
            } else {
              return favorite.favoriteListGitter.isNotEmpty ?
              ListView.builder(
                itemCount: favorite.favoriteListGitter.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    shadowColor: Colors.black26,
                    child: ListTile(
                      onTap: () {
                        routsProvider.topLayerSetter(
                          widget:  ProductDetails(
                            id: favorite.favoriteListGitter[index].id,
                          ),
                          index:routsProvider.topWidgetIndex ,
                          previousIndex: routsProvider.currentIndex,
                        );
                      },
                      leading: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              favorite.favoriteListGitter[index].image,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          favorite.deleteFavorite(favorite.favoriteListGitter[index].id.toString());
                          setState(() {
                            favorite.favoriteListGitter.removeAt(index);
                          });
                        }
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          favorite.favoriteListGitter[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            favorite.favoriteListGitter[index].offerPrice,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            favorite.favoriteListGitter[index].price,
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ) :
              SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noProductFavorite,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        floatingActionButtonLocation:AppLocalizations.of(context)!.localeName =='ar' ?  FloatingActionButtonLocation.startFloat :  FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: accentColor,
          child: Icon(AppLocalizations.of(context)!.localeName =='ar' ? Icons.arrow_back : Icons.arrow_forward),
          onPressed: (){
            routsProvider.topLayerSetter(widget: const SizedBox(), index: routsProvider.previousIndex ,
                previousIndex: routsProvider.lastNavIndex );
          },
        ),
      ),
    );
  }
}
