import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/const.dart';
import 'package:eradko/media/media_provider.dart';
import 'package:eradko/media/read_article.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ArticleListView extends StatefulWidget {
  final String subCategoryId , typeId , categoryId;
  const ArticleListView({Key? key, required this.subCategoryId, required this.typeId, required this.categoryId}) : super(key: key);

  @override
  State<ArticleListView> createState() => _ArticleListViewState();
}

class _ArticleListViewState extends State<ArticleListView> with AutomaticKeepAliveClientMixin{

  final MediaProvider _apiProvider = MediaProvider();
  bool loading = false , loadMore = false;
  int page = 1 ;
  int totalPage = 1 ;
  late final ScrollController _scrollController = ScrollController();

   List<Article> _articles = [] ;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async => fitchArticles());
    _scrollController.addListener(() async {
      var currentScroll = _scrollController.position.pixels ;
      var maxScroll = _scrollController.position.maxScrollExtent ;
      if(maxScroll - currentScroll == 0 && page < totalPage ){
        loadMoreArticles();
      }
    });
    super.initState();
  }

  void loadMoreArticles() {
    if (mounted && page < totalPage ){
      setState(() {
        loadMore = true ;
      });
      page++;

    _apiProvider.getArticles(categoryId: widget.categoryId, subCategoryId: widget.subCategoryId,
        typeId: widget.typeId, locale: AppLocalizations.of(context)!.localeName, page: '$page').then((articlesResponse){
      setState(() {
        if(articlesResponse['status']){
          _articles.addAll(articlesResponse['articles']) ;
          totalPage = articlesResponse['pages'] ;
        }else{
          errorDialog(articlesResponse['error']);
        }
        loadMore = false ;
      });
    });
    }
  }


  fitchArticles(){
    setState(() {
      loading = true ;
    });
    _apiProvider.getArticles(categoryId: widget.categoryId, subCategoryId: widget.subCategoryId,
        typeId: widget.typeId, locale: AppLocalizations.of(context)!.localeName, page: '$page').then((articlesResponse){
      if(mounted){
        if(articlesResponse['status']){
          setState(() {
            _articles = articlesResponse['articles'] ;
            totalPage = articlesResponse['pages'] ;
          });
        }else{
          errorDialog(articlesResponse['error']);
        }
        loading = false ;
      }
    });
  }

  errorDialog(String error){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Icon(Icons.error , color:  Colors.lightGreen,),
                  const SizedBox(height: 20),
                  Text(error),
                  const SizedBox(height: 20),
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 30 , vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    fillColor: accentColor,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.trayAgain , style:  const TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loading ?
    Center(
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(accentColor),
        backgroundColor: Colors.white,
      ),
    ) :
    _articles.isNotEmpty ?
    Stack(
      alignment: Alignment.center,
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 70,top: 10),
          itemCount: _articles.length,
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return RawMaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadArticle(
                      id: _articles[index].id,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'img${_articles[index].id.toString()}',
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 160,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        _articles[index].image,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[800]!.withOpacity(.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        _articles[index].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        loadMore ?
        Positioned(
          bottom: 35,
          child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(accentColor),),),
        ):const SizedBox(),
      ],
    ) :
    SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child:   Center(
        child: Text(
          AppLocalizations.of(context)!.noArticles,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
