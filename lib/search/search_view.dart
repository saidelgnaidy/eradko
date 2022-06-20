import 'package:eradko/category_page_view/product_details.dart';
import 'package:eradko/const.dart';
import 'package:eradko/search/api_search.dart';
import 'package:eradko/search/search_model.dart';
import 'package:eradko/media/read_article.dart';
import 'package:eradko/media/read_releases.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController textCtrl = TextEditingController();
  SearchResultMap? resultMap ;
  bool isLoading = false ;

  Future<void> determineTheView({required String type , required int id , required BuildContext context}) async {
    if (type == 'Product') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetails(
            id:id,
          ),
        ),
      );
    }
    if (type == 'Post') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReadArticle(
            id: id,
          ),
        ),
      );
    }
    if (type == 'Release') {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => ReadReleases(
            id: id,
          ),
        ),
      );
    }
  }

  search(){
    setState(() {
      isLoading = true ;
      resultMap = null ;
    });
    if(textCtrl.text == ''){
      setState(() => isLoading = false );
    }else{
      FetchSearchList().getSearchList(query: textCtrl.text, locale: AppLocalizations.of(context)!.localeName).then((value) {
        setState(() {
          isLoading = false ;
          resultMap = value;
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(color: accentColor.withOpacity(.6)  , width: 1.5 ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (v){
                search();
              },
              cursorColor: textColor,
              controller: textCtrl,
              style: TextStyle(
                color: textColor,
              ),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: textColor,
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search ,color: Colors.redAccent),
                  onPressed: search,
                )
              ),
            ),
          ),
          isLoading ?
          const LinearProgressIndicator():const SizedBox(),
          Expanded(
            child: resultMap == null ?
            Center(child: Text(AppLocalizations.of(context)!.searchAbout)):
            resultMap!.state ? resultMap!.searchResult!.searchItem.isEmpty ? Center(child: Text(AppLocalizations.of(context)!.noResults)):
            ListView.builder(
              itemCount: resultMap!.searchResult!.searchItem.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    onTap: () {
                      determineTheView(
                        type: resultMap!.searchResult!.searchItem[index].type ,
                        id: 1 ,
                        context: context,
                      );
                    },
                    leading: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: CachedNetworkImageProvider(
                              resultMap!.searchResult!.searchItem[index].image,
                          ),
                        ),
                      ),
                    ),
                    title: Text(resultMap!.searchResult!.searchItem[index].name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle:  Text(
                      resultMap!.searchResult!.searchItem[index].type,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ):
            Center(child: Text(resultMap!.error)),
          ),
        ],
      ),
    );
  }
}

