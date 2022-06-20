import 'package:cached_network_image/cached_network_image.dart';
import 'package:eradko/category_page_view/filtter_steps.dart';
import 'package:eradko/home/page_indcator.dart';
import 'package:eradko/home/sections_provider.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../const.dart';
import 'component/category_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
     {
  static final SectionsAndSliders _sectionsAndSliders = SectionsAndSliders();
  final _controller = PageController();

  static List<Section> _sections = [];
  static List<OffersSlider> _sliders = [];

  fitchSections() {
    _sectionsAndSliders
        .getSections(locale: AppLocalizations.of(context)!.localeName)
        .then((responseMap) {
      if (mounted) {
        if (responseMap['status']) {
          setState(() {
            _sections = responseMap['sections'];
          });
        } else {
          _sections = [];
          errorDialog(responseMap['error']);
        }
      }
    });
  }

  fitchSliders() {
    _sectionsAndSliders.getSliders().then((responseMap) {
      if (mounted) {
        if (responseMap['status']) {
          setState(() {
            _sliders = responseMap['sliders'];
          });
        } else {
          _sliders = [];
          errorDialog(responseMap['error']);
        }
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
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: accentColor,
                    onPressed: () {
                      fitchSliders();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'حاول مجدداً',
                      style: TextStyle(color: Colors.white),
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
  void initState() {
    super.initState();
    fitchSliders();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fitchSections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context, listen: false);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          LimitedBox(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: _sliders.isNotEmpty ?
              LimitedBox(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _controller,
                      itemCount: _sliders.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: _sliders[index].image,
                          fit: BoxFit.contain,
                          fadeInDuration: const Duration(microseconds: 200),
                          placeholder: (context, img) => categoryPlaceholder(context),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: DotsIndicator(
                            controller: _controller,
                            itemCount: _sliders.length,
                            color: Colors.white,
                            onPageSelected: (int page) {
                              _controller.animateToPage(
                                page,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) :
              ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: categoryPlaceholder(context),
                  );
                },
              ),
            ),
          ),
          _sections.isNotEmpty ?
          Column(
            children: _sections.map((sec) {
              return GestureDetector(
                onTap: () {
                  routsProvider.topLayerSetter(
                    widget: FilterSteps(
                      sectionId: sec.id,
                      image: sec.image,
                      sectionName: sec.name,
                    ),
                    index: routsProvider.topWidgetIndex,
                    previousIndex: routsProvider.currentIndex,
                    navIndex: routsProvider.lastNavIndex,
                  );
                },
                child: Hero(
                  tag: sec.name,
                  child: SectionTile(
                    img: sec.image,
                    name: sec.name,
                  ),
                ),
              );
            }).toList(),
          ) :
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: categoryPlaceholder(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: categoryPlaceholder(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: categoryPlaceholder(context),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
