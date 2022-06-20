import 'package:eradko/const.dart';
import 'package:eradko/media/media_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPageView extends StatefulWidget {
  final String subCategoryId, typeId, categoryId;

  const VideoPageView({Key? key, required this.subCategoryId, required this.typeId, required this.categoryId}) : super(key: key);
  @override
  State<VideoPageView> createState() => _VideoPageViewState();
}

class _VideoPageViewState extends State<VideoPageView> with AutomaticKeepAliveClientMixin {
  _launch(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  final MediaProvider _apiProvider = MediaProvider();
  bool loading = false, loadMore = false;
  int page = 1;
  int totalPage = 1;
  late ScrollController _scrollController;

  List<MediaVideo> _mediaVideos = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async => fitchVideo());
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      var currentScroll = _scrollController.position.pixels;
      var maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll - currentScroll == 0 && page < totalPage) {
        loadMoreVideo();
      }
    });
    super.initState();
  }

  loadMoreVideo() {
    if (mounted && page < totalPage) {
      setState(() {
        loadMore = true;
      });
      page++;
      _apiProvider
          .getVideos(
              categoryId: widget.categoryId,
              subCategoryId: widget.subCategoryId,
              typeId: widget.typeId,
              locale: AppLocalizations.of(context)!.localeName,
              page: '$page')
          .then((articlesResponse) {
        setState(() {
          if (articlesResponse['status']) {
            setState(() {
              _mediaVideos.addAll(articlesResponse['videos']);
              totalPage = articlesResponse['pages'];
            });
          } else {
            errorDialog(articlesResponse['error']);
          }
          loadMore = false;
        });
      });
    }
  }

  fitchVideo() {
    setState(() {
      loading = true;
    });
    _apiProvider
        .getVideos(
            categoryId: widget.categoryId,
            subCategoryId: widget.subCategoryId,
            typeId: widget.typeId,
            locale: AppLocalizations.of(context)!.localeName,
            page: '$page')
        .then((articlesResponse) {
      if (mounted) {
        if (articlesResponse['status']) {
          setState(() {
            _mediaVideos = articlesResponse['videos'];
            totalPage = articlesResponse['pages'];
            if (kDebugMode) {
              print(_mediaVideos.length);
            }
          });
        } else {
          errorDialog(articlesResponse['error']);
        }
        loading = false;
      }
    });
  }

  errorDialog(String error) {
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
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.lightGreen,
                  ),
                  const SizedBox(height: 20),
                  Text(error),
                  const SizedBox(height: 20),
                  RawMaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    fillColor: accentColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.trayAgain,
                      style: const TextStyle(color: Colors.white),
                    ),
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
    return loading
        ? Center(
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(accentColor),
              backgroundColor: Colors.white,
            ),
          )
        : _mediaVideos.isNotEmpty
            ? Stack(
                alignment: Alignment.center,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70, top: 10),
                    itemCount: _mediaVideos.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _launch(_mediaVideos[index].link);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage('assets/image/logo.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800]!.withOpacity(.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _mediaVideos[index].title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 50,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  loadMore
                      ? Positioned(
                          bottom: 10,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(accentColor),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.noVideos,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              );
  }

  @override
  bool get wantKeepAlive => true;
}
