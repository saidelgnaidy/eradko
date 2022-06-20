import 'package:eradko/category_page_view/product_details.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/const.dart';
import 'package:eradko/media/media_provider.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ReadReleases extends StatefulWidget {
  final int id;
  const ReadReleases({Key? key, required this.id}) : super(key: key);

  @override
  State<ReadReleases> createState() => _ReadReleasesState();
}

class _ReadReleasesState extends State<ReadReleases> {
  _launch(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
  static final MediaProvider _mediaProvider = MediaProvider();
  Releases? releases ;
  bool isLoading = true ;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _mediaProvider.getReleasesDetails(id: widget.id, locale: AppLocalizations.of(context)!.localeName).then((value) {
        if(mounted){
          setState(() {
            releases = value ;
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
        child: isLoading ? const LinearProgressIndicator() : Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              height: 160,
              decoration: BoxDecoration(
                color: Colors.orange[300],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(releases!.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                releases!.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            releases!.properties!.isNotEmpty ?
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Text(  AppLocalizations.of(context)!.properties,
                style: TextStyle(
                  color: accentColor,
                ),
              ),
            ):const SizedBox(),
            Wrap(
              children: releases!.properties!.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductNote(note: AppLocalizations.of(context)!.localeName =='ar' ? e['title_ar'] :e['title_en'] ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                _launch('${releases!.attachment}'
                );
              },
              child: Center(
                child: FittedBox(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    child: Row(
                      children:   [
                        const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                        Text(AppLocalizations.of(context)!.downloadPDF,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
