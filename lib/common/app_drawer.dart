import 'package:eradko/auth/singin.dart';
import 'package:eradko/branches/branche_home.dart';
import 'package:eradko/cart/cart.dart';
import 'package:eradko/common/contact_us.dart';
import 'package:eradko/const.dart';
import 'package:eradko/favorites/favorite.dart';
import 'package:eradko/l10n/locale_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eradko/main.dart';
import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:eradko/pages/models.dart';
import 'package:eradko/pages/pages_provider.dart';
import 'package:eradko/profile/profile_provider.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  static LocaleUser? _localeUser;
  static PagesList _pages = PagesList(data: []);


  @override
  void initState() {
    ProfileProvider().getUserData().then((value) {
      if (mounted) {
        setState(() {
          _localeUser = value;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PagesProvider().getPages(locale: AppLocalizations.of(context)!.localeName).then((value) {
        if(mounted){
          setState(() {
            _pages = value ;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider auth = Provider.of<AuthProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context , listen:  false);

    return Drawer(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        _localeUser == null
                            ? SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.asset("assets/image/user (1).png"),
                              )
                            : Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: _localeUser?.image != 'null' ?
                                    CachedNetworkImageProvider(_localeUser?.image ) :
                                    Image.asset("assets/image/user (1).png").image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          child: _localeUser == null
                              ? Shimmer.fromColors(
                                  baseColor: textColor,
                                  highlightColor: Colors.white70,
                                  child: Text(
                                    '. . . . .',
                                    style: TextStyle(color: textColor, fontSize: 30),
                                  ),
                                )
                              : Text(
                                  _localeUser?.name ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.black38),
                    auth.token == 'null' ? const SizedBox():
                    drawerBtn(
                      txt: AppLocalizations.of(context)!.cart,
                      img: "assets/image/menu_cart.png",
                      onTap: () {
                        Navigator.pop(context);
                        routsProvider.topLayerSetter(widget: const Cart(), index:routsProvider.topWidgetIndex ,previousIndex: routsProvider.currentIndex,
                        );
                      },
                    ),
                    ListTile(
                      onTap: (){
                        Navigator.pop(context);
                        routsProvider.topLayerSetter(widget: const SizedBox(), index:0 ,previousIndex: 0,navIndex: 0);
                      },
                      title: Text(AppLocalizations.of(context)!.home,
                        style: TextStyle(color: textColor, fontSize: 13.0),
                      ),
                      leading: SizedBox(width: 25,height: 25,child: Icon(Icons.home_rounded , color: accentColor,size: 30,),)
                    ),
                    auth.token == 'null' ? const SizedBox():
                    ListTile(
                        onTap: (){
                          Navigator.pop(context);
                          routsProvider.topLayerSetter(widget: const SizedBox(), index:4 ,previousIndex: 4,navIndex: 4);
                        },
                        title: Text(AppLocalizations.of(context)!.profile,
                          style: TextStyle(color: textColor, fontSize: 13.0),
                        ),
                        leading: SizedBox(width: 25,height: 25,child: Icon(Icons.person , color: accentColor,size: 30,),)
                    ),
                    ListTile(
                        onTap: (){
                          Navigator.pop(context);
                          routsProvider.topLayerSetter(widget: const SizedBox(), index:1 ,previousIndex: 1,navIndex: 1);
                        },
                        title: Text(AppLocalizations.of(context)!.offers,
                          style: TextStyle(color: textColor, fontSize: 13.0),
                        ),
                        leading: SizedBox(width: 25,height: 25,child: Icon(Icons.local_offer_rounded , color: accentColor,size: 30,),)
                    ),
                    ListTile(
                        onTap: (){
                          Navigator.pop(context);
                          routsProvider.topLayerSetter(widget: const SizedBox(), index:3 ,previousIndex:3,navIndex: 3);
                        },
                        title: Text(AppLocalizations.of(context)!.media,
                          style: TextStyle(color: textColor, fontSize: 13.0),
                        ),
                        leading: SizedBox(width: 25,height: 25,child: Icon(Icons.photo_camera_front , color: accentColor,size: 30,),)
                    ),
                    auth.token == 'null' ? const SizedBox():
                    ListTile(
                      onTap: (){
                        Navigator.pop(context);
                        routsProvider.topLayerSetter(widget: const Favorite(), index:routsProvider.topWidgetIndex,previousIndex: routsProvider.previousIndex
                        );
                      },
                      title: Text(AppLocalizations.of(context)!.myFavorites,
                        style: TextStyle(color: textColor, fontSize: 13.0),
                      ),
                      leading: SizedBox(width: 25,height: 25,child: Icon(Icons.favorite , color: accentColor,size: 30,),
                      ),
                    ),
                    drawerBtn(
                      txt: AppLocalizations.of(context)!.branches,
                      img: "assets/image/big-store.png",
                      onTap: () {
                        Navigator.pop(context);
                        routsProvider.topLayerSetter(widget: const BranchesHome(), index:routsProvider.topWidgetIndex, previousIndex: routsProvider.currentIndex );
                      },
                    ),
                    _pages.data.isNotEmpty ?
                    Column(
                      children: _pages.data.map((page){
                        return fadeScale(
                           ListTile(
                            onTap: (){
                              pageDialog(context, page);
                            },
                            title: Text(page.name,
                              style: TextStyle(color: textColor, fontSize: 13.0),
                            ),
                            leading: SizedBox(
                              width: 25,height: 25,
                              child: Icon(page.slug == 'privacy-policy' ?
                              Icons.policy : page.slug == 'terms' ?
                              Icons.gavel : Icons.description,
                                color: accentColor,size: 30,
                              ),
                            ),
                          ),true
                        );
                      }).toList(),
                    ):const SizedBox(),
                    drawerBtn(
                      txt:AppLocalizations.of(context)!.callUs,
                      img: "assets/image/invitation.png",
                      onTap: () async {
                        showContactUsDialog(context);
                      },
                    ),
                    ListTile(
                      onTap: () {
                        if(auth.token != 'null') {
                          auth.logout();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MyApp()), (route) => false);
                        }else{
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SignIn()), (route) => false);
                        }

                      },
                        title: Text(auth.token == 'null' ? AppLocalizations.of(context)!.register : AppLocalizations.of(context)!.logOut,
                          style: TextStyle(color: textColor, fontSize: 13.0),
                        ),
                      leading: SizedBox(width: 25,height: 25,child: Icon(Icons.exit_to_app , color: accentColor,size: 30,),),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _buildLangSwitch(context: context, localeProvider: localeProvider),
            ),
          ],

      ),
    );
  }
}

drawerBtn({required String txt, required Function() onTap, required String img}) {
  return ListTile(
    onTap: onTap,
    title: Text(
      txt,
      style: TextStyle(color: textColor, fontSize: 13.0),
    ),
    leading: Image.asset(img,
      width: 25,
      height: 25,
    ),
  );
}

Widget _buildLangSwitch(
    {required LocaleProvider localeProvider, required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      localeProvider.switchLang();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()), (route) => false);
      },
    child: AnimatedContainer(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(50),
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.decelerate,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                localeProvider.locale.languageCode == 'ar' ? 'English' : 'العربية',
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              AppLocalizations.of(context)!.language,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    ),
  );
}


pageDialog(context , PagesModel page){
  return showDialog(context: context, builder: (_){
    return StatefulBuilder(
      builder: (context , setState) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(page.name,textScaleFactor: 1.3,),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HtmlWidget( page.content,
                          isSelectable: true,
                          onErrorBuilder: (context, element, error) => Text('$element error: $error'),
                          onLoadingBuilder: (context, element, loadingProgress) => const CircularProgressIndicator(),
                          renderMode: RenderMode.column,
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: RawMaterialButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      fillColor: accentColor,
                      shape: const StadiumBorder(),
                      child: Text(AppLocalizations.of(context)!.close,style:  const TextStyle(color: Colors.white) ,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    ) ;
  });
}

Widget fadeScale(Widget widget , bool active) {
  return Visibility(
    visible: active,
    child: TweenAnimationBuilder(
      tween: Tween<double>(begin: .98 , end: 1.0),
      duration: const Duration(milliseconds:300),
      curve: Curves.decelerate,
      builder: (context,double value , child){
        return Opacity(
          opacity: (value - .98)*49.99999999,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        ) ;
      },
      child: widget,
    ),
  );
}
