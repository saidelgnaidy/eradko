import 'package:eradko/home/component/category_tile.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:eradko/provider/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:eradko/const.dart';
import 'package:eradko/category_page_view/all_products.dart';
import 'models/categories_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class FilterSteps extends StatefulWidget {
  final int sectionId;
  final String image , sectionName;
  const FilterSteps({Key? key, required this.sectionId, required this.image, required this.sectionName}) : super(key: key);

  @override
  State<FilterSteps> createState() => _FilterStepsState();
}

class _FilterStepsState extends State<FilterSteps> {
  static final CategoriesProvider apiProvider = CategoriesProvider();
  List<Category> _categories = [];
  String selectedCategory = '1' , selectedSup = '' , selectedType = '' , selectedSupType = '';
  bool loading = true ;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      apiProvider.getMainCategory(id: widget.sectionId, locale: AppLocalizations.of(context)!.localeName).then((value) {
        if (mounted) {
          setState(() {
            loading =false;
            _categories = value;
          });
        }
      });
    });

    super.initState();
  }


  navigateToProducts(){
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => AllProducts(
          isOffers: false,
          catId: selectedCategory,
          sectionImg: widget.image,
          subCategoryId: selectedSup,
          typeId: selectedType,
          sectionName: widget.sectionName,
          supType: selectedSupType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context) ;
    final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context , listen: false);

    return WillPopScope(
      onWillPop: () async {
        routsProvider.topLayerSetter(widget: const SizedBox(), index: 0 , previousIndex: 0 );
        return false ;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero( tag : widget.image,child: SectionTile(name: widget.sectionName, img: widget.image)),
              loading ?
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: CircularProgressIndicator(),
                ),
              ): _categories.isEmpty ?
              const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Text('No Categories yet'),
                  ),
                ):
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text( AppLocalizations.of(context)!.cheekProductSearch,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor.withOpacity(.3) , width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ExpansionPanelList.radio(
                            dividerColor: Colors.transparent,
                            elevation: 0,
                            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 5),
                            children: _categories.where((category) =>category.subCategories.isNotEmpty).map((category) {
                              return ExpansionPanelRadio(
                                value: category.id,
                                canTapOnHeader: true,
                                headerBuilder: (context, isExpanded) {
                                  return _buildHeader(
                                    onTap: (){
                                      categoriesProvider.categoryPathSetter(CategoryPath(
                                        categoryName: category.name,
                                        supCatName: '', typeName: '',
                                        supTypeName: '',
                                      ));
                                      selectedCategory = '${category.id}' ;
                                      selectedSup = '' ;
                                      selectedType = '' ;
                                      navigateToProducts();
                                    },
                                    name: category.name,
                                    image: category.image,
                                  );
                                },
                                body: Column(
                                  children: category.subCategories.map((supCat) {
                                    if (supCat.types.isEmpty) {
                                      return Column(
                                        children: [
                                          _outLinedContainer(
                                            onTap:  (){
                                              categoriesProvider.categoryPathSetter(CategoryPath(
                                                categoryName: category.name,
                                                supCatName: supCat.name, typeName: '',
                                                supTypeName: '',
                                              ));
                                              selectedCategory = '${category.id}' ;
                                              selectedSup = '${supCat.id}';
                                              selectedType = '' ;
                                              navigateToProducts();
                                            },
                                            name: supCat.name,
                                            image: supCat.image,
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: textColor.withOpacity(.3) , width: 1),
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: ExpansionPanelList.radio(
                                            dividerColor: Colors.transparent,
                                            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 5),
                                            elevation: 0,
                                            children: supCat.types.map((type) {
                                             if( type.subTypes.isEmpty){
                                               return ExpansionPanelRadio(
                                                 value: type.id,
                                                 canTapOnHeader: true,
                                                 headerBuilder: (context, isExpanded) {
                                                   return _buildHeader(
                                                     name: supCat.name,
                                                     image: supCat.image,
                                                     onTap:  (){
                                                       categoriesProvider.categoryPathSetter(CategoryPath(
                                                         categoryName: category.name,
                                                         supCatName: supCat.name,
                                                         typeName: '',
                                                         supTypeName: '',
                                                       ));
                                                       selectedCategory = '${category.id}' ;
                                                       selectedSup = '${supCat.id}';
                                                       selectedType = '' ;
                                                       selectedSupType = '' ;
                                                       navigateToProducts();
                                                     },
                                                   );
                                                 },
                                                 body: _outLinedContainer(
                                                   onTap: (){
                                                     categoriesProvider.categoryPathSetter(CategoryPath(
                                                       categoryName: category.name,
                                                       supCatName: supCat.name,
                                                       typeName: type.name,
                                                       supTypeName: '',
                                                     ));
                                                     selectedCategory = '${category.id}' ;
                                                     selectedSup = '${supCat.id}';
                                                     selectedType = '${type.id}' ;
                                                     navigateToProducts();
                                                   },
                                                   name: type.name,
                                                   image: type.image,
                                                 ),
                                               );
                                             }else{
                                               return ExpansionPanelRadio(
                                                 value: type.id,
                                                 canTapOnHeader: true,
                                                 headerBuilder: (context, isExpanded) {
                                                   return _buildHeader(
                                                     onTap:  (){
                                                       categoriesProvider.categoryPathSetter(CategoryPath(
                                                         categoryName: category.name,
                                                         supCatName: supCat.name,
                                                         typeName: '',
                                                         supTypeName: '',
                                                       ));
                                                       selectedCategory = '${category.id}' ;
                                                       selectedSup = '${supCat.id}';
                                                       selectedType = '' ;
                                                       selectedSupType = '';
                                                       navigateToProducts();
                                                     },
                                                     name: supCat.name,
                                                     image: supCat.image,
                                                   );
                                                 },
                                                 body: ExpansionTile(
                                                   title: Text(type.name ,style: textStyle),
                                                   leading: ClipRRect(
                                                     borderRadius: BorderRadius.circular(6),
                                                     child: type.image != '' ? SizedBox(
                                                       height: 40,
                                                       child: CachedNetworkImage(
                                                         imageUrl: type.image,
                                                         fit: BoxFit.cover,
                                                         fadeInDuration: const Duration(microseconds: 200),
                                                         placeholder: (context, img) => categoryPlaceholder(context),
                                                       ),
                                                     ):
                                                     Container(height: 40 , color: Colors.grey[200],),
                                                   ),
                                                   children: [
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                       children: [
                                                         RawMaterialButton(
                                                           fillColor: Colors.grey[100],
                                                           shape:const StadiumBorder(),
                                                           child: Text(AppLocalizations.of(context)!.all,style: textStyle),
                                                           onPressed: () {
                                                             categoriesProvider.categoryPathSetter(CategoryPath(
                                                               categoryName: category.name,
                                                               supCatName: supCat.name,
                                                               typeName: type.name,
                                                               supTypeName: AppLocalizations.of(context)!.all,
                                                             ));
                                                             selectedCategory = '${category.id}' ;
                                                             selectedSup = '${supCat.id}';
                                                             selectedType = type.id.toString() ;
                                                             selectedSupType = '';
                                                             navigateToProducts();
                                                           },
                                                         ),
                                                         RawMaterialButton(
                                                           fillColor: Colors.grey[100],
                                                           shape:const StadiumBorder(),
                                                           child: Text(AppLocalizations.of(context)!.protected,style: textStyle),
                                                           onPressed: () {
                                                             categoriesProvider.categoryPathSetter(CategoryPath(
                                                               categoryName: category.name,
                                                               supCatName: supCat.name,
                                                               typeName: type.name,
                                                               supTypeName: AppLocalizations.of(context)!.protected,
                                                             ));
                                                             selectedCategory = '${category.id}' ;
                                                             selectedSup = '${supCat.id}';
                                                             selectedType = type.id.toString() ;
                                                             selectedSupType = 'protected';
                                                             navigateToProducts();
                                                           },
                                                         ),
                                                         RawMaterialButton(
                                                           fillColor: Colors.grey[100],
                                                           shape:const StadiumBorder(),
                                                           child: Text(AppLocalizations.of(context)!.public ,style: textStyle),
                                                           onPressed: () {
                                                             categoriesProvider.categoryPathSetter(CategoryPath(
                                                               categoryName: category.name,
                                                               supCatName: supCat.name,
                                                               typeName: type.name,
                                                               supTypeName: AppLocalizations.of(context)!.public,
                                                             ));
                                                             selectedCategory = '${category.id}' ;
                                                             selectedSup = '${supCat.id}';
                                                             selectedType = type.id.toString() ;
                                                             selectedSupType = 'public';
                                                             navigateToProducts();
                                                           },
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 )
                                               );
                                             }
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList(),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          children: _categories.where((category) =>category.subCategories.isEmpty).map((category){
                            return _buildHeader(
                              onTap: (){
                                categoriesProvider.categoryPathSetter(CategoryPath(
                                  categoryName: category.name,
                                  supCatName: '',
                                  typeName: '',
                                  supTypeName: '',
                                ));
                                selectedCategory = '${category.id}' ;
                                selectedSup = '' ;
                                selectedType = '' ;
                                navigateToProducts();
                              },
                              name: category.name,
                              image: category.image,
                              //height: 55,
                            );
                          } ).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
        floatingActionButtonLocation: AppLocalizations.of(context)!.localeName =='ar' ?
        FloatingActionButtonLocation.startFloat: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: RawMaterialButton(
            shape: const StadiumBorder(),
            onPressed: (){
              routsProvider.topLayerSetter(widget: const SizedBox(), index: 0 , previousIndex: 0 );
            },
            fillColor: accentColor,
            child: Icon(AppLocalizations.of(context)!.localeName =='ar' ? Icons.arrow_back : Icons.arrow_forward , color: Colors.white,),
          ),
        ),
      ),
    );
  }
}

Widget _buildHeader({required Function() onTap ,required  String  name , required String image}){
  return InkWell(
    onTap: onTap,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          child: SizedBox(
            width: 100,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: image != '' ? CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(microseconds: 200),
                placeholder: (context, img) =>
                    FittedBox(
                      child: SizedBox(
                        width: 100,
                        child: categoryPlaceholder(context),
                      ),
                    ),
              ):
              Container(height: 50 , color: Colors.grey[200],),
            ),
          ),
        ),
        Expanded(
          child: Text(name,
            style: textStyle,
          ),
        ),
      ],
    ),
  );
}

Widget _outLinedContainer({ required Function() onTap ,required String name, required String image }) {
  return ListTile(
    onTap: onTap,
    title: Padding(
      padding: const EdgeInsets.symmetric(),
      child: Text(name,
        style: textStyle,
      ),
    ),
    leading: SizedBox(
      width:  50,
      height: 40 ,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: image != '' ? CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(microseconds: 200),
          placeholder: (context, img) => categoryPlaceholder(context),
        ):
        Container(height: 40 , color: Colors.grey[200],),
      ),
    ),
  );
}

