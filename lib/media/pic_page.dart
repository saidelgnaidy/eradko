import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/const.dart';
import 'package:eradko/media/media_provider.dart';
import 'package:eradko/media/phot_view_page.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PhotoPageView extends StatefulWidget {
  final String subCategoryId , typeId , categoryId;

  const PhotoPageView({Key? key, required this.subCategoryId, required this.typeId, required this.categoryId}) : super(key: key);

  @override
  State<PhotoPageView> createState() => _PhotoPageViewState();
}

class _PhotoPageViewState extends State<PhotoPageView> with AutomaticKeepAliveClientMixin {

  final MediaProvider _apiProvider = MediaProvider();
  bool loading = false , loadMore = false;
  int page = 1 ;
  int totalPage = 1 ;
  final ScrollController _scrollController = ScrollController();
  List<MediaPhoto> _mediaPhoto = [] ;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async =>fitchGallery());
    _scrollController.addListener(() async {
      var currentScroll = _scrollController.position.pixels ;
      var maxScroll = _scrollController.position.maxScrollExtent ;
      if(maxScroll - currentScroll == 0 && page < totalPage ){
        loadMorePhotos();
      }
    });
    super.initState();
  }

  loadMorePhotos() {
    if (mounted && page < totalPage ){
      setState(() {
        loadMore = true ;
      });
      page++;
      _apiProvider.getGallery(categoryId: widget.categoryId, subCategoryId: widget.subCategoryId,
          typeId: widget.typeId, locale: AppLocalizations.of(context)!.localeName, page: '$page').then((galleryRes){
        setState(() {
          if(galleryRes['status']){
            _mediaPhoto.addAll(galleryRes['gallery']) ;
            totalPage = galleryRes['pages'] ;
          }else{
            errorDialog(galleryRes['error']);
          }
          loadMore = false ;
        });
      });
    }
  }

  fitchGallery(){
    setState(() {
      loading = true ;
    });
    _apiProvider.getGallery(categoryId: widget.categoryId, subCategoryId: widget.subCategoryId,
        typeId: widget.typeId, locale: AppLocalizations.of(context)!.localeName, page: '$page').then((galleryRes){
      if(mounted){
        if(galleryRes['status']){
          setState(() {
            _mediaPhoto = galleryRes['gallery'] ;
            totalPage = galleryRes['pages'] ;
          });
        }else{
          errorDialog(galleryRes['error']);
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
    ) : _mediaPhoto.isNotEmpty ?
    Stack(
      alignment: Alignment.center,
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: .9),
          itemCount: _mediaPhoto.length,
          padding: const EdgeInsets.only(bottom: 70,top: 10),
          itemBuilder: (context , index) {
            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewPage(
                      id: _mediaPhoto[index].id,
                      img: _mediaPhoto[index].image,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(10),
                  image:  DecorationImage(
                    image: CachedNetworkImageProvider(
                      _mediaPhoto[index].image,
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
                      _mediaPhoto[index].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
          bottom: 10,
          child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(accentColor),),),
        ):const SizedBox(),
      ],
    ):
    SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child:   Center(
        child: Text(
          AppLocalizations.of(context)!.noImage,
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
