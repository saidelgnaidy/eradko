import 'package:eradko/category_page_view/models/product_model.dart';
import 'package:eradko/category_page_view/product_details.dart';
import 'package:eradko/category_page_view/product_tile.dart';
import 'package:eradko/category_page_view/products_provider.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/home/component/category_tile.dart';
import 'package:eradko/provider/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class AllProducts extends StatefulWidget {
  final String sectionImg , sectionName , subCategoryId , typeId , catId , supType;
  final bool isOffers ;
  const AllProducts({Key? key, required this.sectionImg, required this.catId,
    required this.subCategoryId, required this.typeId, required this.sectionName, required this.isOffers, required this.supType}) : super(key: key);

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {

  final ProductsProvider _productsProvider = ProductsProvider() ;
  List<ProductTileDetails> _allProducts = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  late ScrollController _scrollController;
  bool loading = true ;
  bool loadMore = false ;
  int page = 1 ;
  int totalPage = 1 ;

  fitchProducts(){
    if (mounted  ){
      setState(() => loading = true );
      if(widget.isOffers){
        _productsProvider.getAllOffers(locale: AppLocalizations.of(context)!.localeName, count: '10').then((value) {
          if(mounted){
            setState(() {
              _allProducts = value['product_List'] ;
              totalPage = value['pages'];
              loading = false ;
            });
          }
        });
      }else{
        _productsProvider.getAllProducts(categoryId: widget.catId,  locale:AppLocalizations.of(context)!.localeName,
            page: page.toString() ,typeId: widget.typeId,subCategoryId: widget.subCategoryId , supType: widget.supType).then((value) {
          if(mounted){
            setState(() {
              _allProducts = value['product_List'] ;
              totalPage = value['pages'];
              loading = false ;
            });
          }
        });
      }
    }
  }

  loadMoreProducts(){
    if (page < totalPage ){
      setState(() => loadMore = true );
      page++;
      if(widget.isOffers){
        _productsProvider.getAllOffers(locale: AppLocalizations.of(context)!.localeName, page: page).then((value) {
          if(mounted){
            setState(() {
              _allProducts = value['product_List'] ;
              totalPage = value['pages'];
              loadMore = false ;
            });
          }
        });
      }else{
        _productsProvider.getAllProducts(categoryId: widget.catId,  locale: AppLocalizations.of(context)!.localeName ,
            page: page.toString() ,typeId: widget.typeId,subCategoryId: widget.subCategoryId).then((value) {
          if(mounted){
            setState(() {
              _allProducts = value['product_List'] ;
              totalPage = value['pages'];
              loadMore = false ;
            });
          }
        });
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async =>fitchProducts());
    _scrollController = ScrollController();
    _scrollController.addListener(()  {
      var currentScroll = _scrollController.position.pixels ;
      var maxScroll = _scrollController.position.maxScrollExtent ;
      if(maxScroll - currentScroll == 0 && page < totalPage ){
        loadMoreProducts();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context) ;
    return  Scaffold(
      key: _key,
      appBar: widget.isOffers ? null : buildAppBar(context, showCart: true,needPop: true),
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Column(
              children:  [

                Column(
                  children: [
                    widget.isOffers ?
                    Stack(
                      children: [
                        Image.asset('assets/image/offers.png'),
                        Positioned(
                          bottom: 10,
                          child: SizedBox(
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,),
                              child: Text(AppLocalizations.of(context)!.localeName == 'ar'? 'عروض ايرادكو' : 'Eradco Offers',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ) :
                    Hero(
                      tag: widget.sectionImg,
                      child: SectionTile(
                        img: widget.sectionImg,
                        name:widget.sectionName,
                      ),
                    ),
                    widget.isOffers ?
                    const SizedBox():
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: size.width,
                        child: Row(
                          children: [
                            Text(categoriesProvider.categoryPath.categoryName,
                              style: const TextStyle(
                                color: Color(0xff6D6D6D),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13,
                              ),
                            ),
                            categoriesProvider.categoryPath.supCatName != '' ?
                            Text('   >   ${categoriesProvider.categoryPath.supCatName}' ,
                              style: const TextStyle(
                                color: Color(0xff6D6D6D),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13,
                              ),
                            ):const SizedBox(),
                            categoriesProvider.categoryPath.typeName != '' ?
                            Text('   >   ${categoriesProvider.categoryPath.typeName}' ,
                              style: const TextStyle(
                                color: Color(0xff6D6D6D),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13,
                              ),
                            ):const SizedBox(),
                            categoriesProvider.categoryPath.supTypeName != '' ?
                            Text('   >   ${categoriesProvider.categoryPath.supTypeName}' ,
                              style: const TextStyle(
                                color: Color(0xff6D6D6D),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13,
                              ),
                            ):const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1.5, color: Colors.black12),
                  ],
                ),
                loading ?
                Center(
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(accentColor),
                    backgroundColor: Colors.white,
                  ),
                ): _allProducts.isEmpty ?
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(AppLocalizations.of(context)!.noProduct,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ):
                Stack(
                  alignment: Alignment.center,
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 5,bottom: 120,left: 5,right: 5),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2 ,childAspectRatio: .8),
                      itemCount: _allProducts.length ,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> ProductDetails(id: _allProducts[index].id,),),);
                            },
                          child: ProductTileInfo(product: _allProducts[index]),
                        );
                      },
                    ),
                    loadMore ?
                    Positioned(
                      bottom: 35,
                      child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(accentColor),),),
                    ):const SizedBox(),
                  ],
                ) ,
              ],
            ),
          ),
          widget.isOffers ?
          const SizedBox() :
          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox(
              width: 60,
              height: 60,
              child: RawMaterialButton(
                shape: const StadiumBorder(),
                onPressed: (){
                  Navigator.pop(context);
                },
                fillColor: accentColor,
                child: Icon(AppLocalizations.of(context)!.localeName =='ar' ? Icons.arrow_back : Icons.arrow_forward , color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





