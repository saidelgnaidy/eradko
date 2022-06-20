import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/const.dart';
import 'package:eradko/media/media_provider.dart';
import 'package:eradko/media/read_releases.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ReleasesPageView extends StatefulWidget {
  final String subCategoryId, typeId, categoryId;
  const ReleasesPageView(
      {Key? key,
      required this.subCategoryId,
      required this.typeId,
      required this.categoryId})
      : super(key: key);
  @override
  State<ReleasesPageView> createState() => _ReleasesPageViewState();
}

class _ReleasesPageViewState extends State<ReleasesPageView>
    with AutomaticKeepAliveClientMixin {
  final MediaProvider _apiProvider = MediaProvider();
  bool loading = false, loadMore = false;
  int page = 1;
  int totalPage = 1;
  final ScrollController _scrollController = ScrollController();
  List<Releases> _mediaReleases = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async => fitchReleases());

    _scrollController.addListener(() async {
      var currentScroll = _scrollController.position.pixels;
      var maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll - currentScroll == 0 && page < totalPage) {
        loadMoreReleases();
      }
    });
    super.initState();
  }

  void loadMoreReleases() {
    if (mounted && page < totalPage) {
      setState(() {
        loadMore = true;
      });
      page++;
      _apiProvider
          .getReleases(
              categoryId: widget.categoryId,
              subCategoryId: widget.subCategoryId,
              typeId: widget.typeId,
              locale: AppLocalizations.of(context)!.localeName,
              page: '$page')
          .then((response) {
        setState(() {
          if (response['status']) {
            _mediaReleases.addAll(response['releases']);
            totalPage = response['pages'];
          } else {
            errorDialog(response['error']);
          }
          loadMore = false;
        });
      });
    }
  }

  fitchReleases() {
    setState(() {
      loading = true;
    });
    _apiProvider
        .getReleases(
            categoryId: widget.categoryId,
            subCategoryId: widget.subCategoryId,
            typeId: widget.typeId,
            locale: AppLocalizations.of(context)!.localeName,
            page: '$page')
        .then((response) {
      if (mounted) {
        if (response['status']) {
          setState(() {
            _mediaReleases = response['releases'];
            totalPage = response['pages'];
          });
        } else {
          errorDialog(response['error']);
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: accentColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.trayAgain,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.justify),
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
        : _mediaReleases.isNotEmpty
            ? Stack(
                alignment: Alignment.center,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: _mediaReleases.length,
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return RawMaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadReleases(
                                id: _mediaReleases[index].id,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        _mediaReleases[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Center(
                                  child: Text(
                                    _mediaReleases[index].title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                  AppLocalizations.of(context)!.noReleases,
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
