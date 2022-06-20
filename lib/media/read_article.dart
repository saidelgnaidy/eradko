import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/const.dart';
import 'package:eradko/media/media_provider.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ReadArticle extends StatefulWidget {
  final int id ;
  const ReadArticle({Key? key, required this.id}) : super(key: key);

  @override
  State<ReadArticle> createState() => _ReadArticleState();
}

class _ReadArticleState extends State<ReadArticle> {

  Article? article ;
  bool isLoading = true ;
  final MediaProvider _mediaProvider = MediaProvider() ;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      _mediaProvider.getArticleDetails(id: widget.id, locale: AppLocalizations.of(context)!.localeName).then((value) {
        if(mounted){
          setState(() {
            article = value ;
            isLoading = false ;
          });
        }
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context, showCart: true,needPop: true),
      body: SingleChildScrollView(
        child: isLoading ? const LinearProgressIndicator():  Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              height: 160,
              decoration: BoxDecoration(
                color: Colors.orange[300],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(article!.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(article!.title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('${article!.description}' ,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
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
