import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/category_page_view/all_products.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/common/app_drawer.dart';
import 'package:eradko/const.dart';
import 'package:eradko/profile/empty_profile.dart';
import 'package:eradko/profile/notify/notifications_provider.dart';
import 'package:eradko/search/search_view.dart';
import 'package:eradko/media/media.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:eradko/profile/profile_landding.dart';
import 'package:flutter/material.dart';
import 'package:eradko/home/home_view.dart';
import 'package:provider/provider.dart';

class LandingWrapper extends StatefulWidget {
  const LandingWrapper({Key? key}) : super(key: key);

  @override
  State<LandingWrapper> createState() => _LandingWrapperState();
}

class _LandingWrapperState extends State<LandingWrapper> {

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToastMag(msg: 'Double Tap to Exit');
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context);
    final AuthProvider auth = Provider.of<AuthProvider>(context);
    final NotificationsProvider notify = Provider.of<NotificationsProvider>(context);

    return  WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar:buildAppBar(context, showCart: true),
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: routsProvider.currentIndex,
                sizing: StackFit.passthrough,
                children:  [
                  const HomeScreen(),
                   const AllProducts(
                    isOffers: true,
                    typeId: '',
                    subCategoryId: '',
                    catId: '',
                    sectionImg: '',
                    sectionName: '',
                    supType: '',
                  ),
                  const SearchPage(),
                  const MediaLanding(),
                  auth.token == 'null' ?
                  const NotAuthenticated() :
                  const ProfileLanding(),
                  routsProvider.topWidget,
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            BottomNavigationBar(
              onTap: (index){
                routsProvider.topLayerSetter(widget: const SizedBox(), index:index, previousIndex: index,navIndex: index);
              },
              currentIndex: routsProvider.lastNavIndex,
              selectedItemColor: const Color(0xff0e9e59),
              unselectedItemColor: const Color(0xff878787),
              items: const [
                BottomNavigationBarItem(label: '',icon: Icon(Icons.home_rounded)),
                BottomNavigationBarItem(label: '',icon: Icon(Icons.local_offer_rounded)),
                BottomNavigationBarItem(label: '',icon: Icon(Icons.search_rounded)),
                BottomNavigationBarItem(label: '',icon: Icon(Icons.photo_camera_front)),
                BottomNavigationBarItem(label: '',icon: Icon(Icons.person)),
              ],
            ),
            !notify.allSeen ?
            Positioned(
              right: Lang.of(context).localeName == 'en' ? 8 : MediaQuery.of(context).size.width-18,
              top: 8,
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color:  Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ):const SizedBox(),
          ],
        ),
      ),
    );
  }
}


