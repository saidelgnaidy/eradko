import 'package:eradko/const.dart';
import 'package:eradko/media/articels.dart';
import 'package:eradko/media/pic_page.dart';
import 'package:eradko/media/releases_view.dart';
import 'package:eradko/media/vedios_view.dart';
import 'package:eradko/media/widgits/reused_wedgits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MediaLanding extends StatefulWidget {
  const MediaLanding({Key? key}) : super(key: key);

  @override
  _MediaLandingState createState() => _MediaLandingState();
}

class _MediaLandingState extends State<MediaLanding>
    with SingleTickerProviderStateMixin  {
  late TabController ctrl;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ctrl = TabController(vsync: this, length: 4, initialIndex: 0)
      ..addListener(() {
        if (currentIndex != ctrl.index) {
          setState(() {
            currentIndex = ctrl.index;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: Text(AppLocalizations.of(context)!.media,
              style: TextStyle(color: textColor),
            ),
          ),
          TabBar(
            controller: ctrl,
            indicatorColor: Colors.transparent,
            labelPadding: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            tabs: [
              MediaBarItem(
                active: currentIndex == 0,
                title: AppLocalizations.of(context)!.photo,
              ),
              MediaBarItem(
                active: currentIndex == 1,
                title: AppLocalizations.of(context)!.videos,
              ),
              MediaBarItem(
                active: currentIndex == 2,
                title:AppLocalizations.of(context)!.releases,
              ),
              MediaBarItem(
                active: currentIndex == 3,
                title: AppLocalizations.of(context)!.articles,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: ctrl,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                 PhotoPageView(categoryId: '',subCategoryId: '',typeId: '',),
                 VideoPageView(typeId: '',subCategoryId: '',categoryId: '',),
                ReleasesPageView(typeId: '',subCategoryId: '',categoryId: '',),
                ArticleListView(subCategoryId: '', typeId: '', categoryId: ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

