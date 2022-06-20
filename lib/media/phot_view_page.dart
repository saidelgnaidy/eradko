
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/const.dart';
import 'package:eradko/media/media_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class PhotoViewPage extends StatefulWidget {
  final int id ;
  final String  img ;
  const PhotoViewPage({Key? key, required this.id, required this.img}) : super(key: key);

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  final _controller = PageController();
  List<String> images = [] ;
  bool loading = true ;

  @override
  void initState() {
    images.add(widget.img);
    WidgetsBinding.instance.addPostFrameCallback((_) async =>
    MediaProvider().getGalleryDetails(id: widget.id, locale: AppLocalizations.of(context)!.localeName).then((value) {
      if(mounted){
        setState(() {
          loading = false ;
          for (var img in value.images) {
            images.add(img);
          }
        });
      }
    }));
    super.initState();
  }

  imageDialog(String img){
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).padding.top+55),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PhotoView(
                      imageProvider:  CachedNetworkImageProvider(img,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: RawMaterialButton(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        onPressed: ()=>Navigator.pop(context) ,
                        shape: const StadiumBorder(),
                        fillColor: accentColor,
                        child: Text(Lang.of(context).close , style: const TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, showCart: true,needPop: true),
      body: Stack(
        children: [
          GridView.builder(
            controller: _controller,
            itemCount: images.length,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){
                  imageDialog(images[index]);
                },
                child: Card(
                  elevation: 5,
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    placeholder: (context, img) => categoryPlaceholder(context),
                    errorWidget: (context, image, error) {
                      return const Placeholder();
                    },
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: .9),
          ),
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


