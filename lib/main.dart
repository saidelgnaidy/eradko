
import 'dart:io';
import 'package:eradko/cart/cart_provider.dart';
import 'package:eradko/commercial_id/user_cmmercial_provider.dart';
import 'package:eradko/const.dart';
import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/l10n/locale_provider.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:eradko/payment/payment_provider.dart';
import 'package:eradko/profile/adresses_provider.dart';
import 'package:eradko/profile/notify/notifications_provider.dart';
import 'package:eradko/provider/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:eradko/favorites/favorite_provider.dart';
import 'package:eradko/home/home_wraper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String loadedLocale = 'ar';
  int backPressed = 0;

  @override
  void initState() {
    LocaleProvider().getLocale().then((value) {
      loadedLocale = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ChangeNotifierProvider(create: (_) => CategoriesProvider()),
          ChangeNotifierProvider(create: (_) => AddressesProvider()),
          ChangeNotifierProvider(create: (_) => RoutsProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
          ChangeNotifierProvider(create: (_) => UserCommercialProvider()),
          ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ],
        child: ChangeNotifierProvider(
          create: (BuildContext context) => LocaleProvider(),
          builder: (context, child) {
            final localeProvider = Provider.of<LocaleProvider>(context);
            return FutureBuilder<String>(
              future: localeProvider.getLocale(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Material();
                } else {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily:
                          GoogleFonts.tajawal(fontWeight: FontWeight.w500)
                              .fontFamily,
                    ),
                    supportedLocales: const [
                      Locale('en'),
                      Locale('ar'),
                    ],
                    locale: Locale(snapshot.data.toString()),
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    home: const AppWrapper(),
                    routes: {
                      '/landingWrapper': (_) => const LandingWrapper(),
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    checkNetworkConnection(context);
    AuthProvider().getToken();
    super.initState();
  }

  checkNetworkConnection(BuildContext context) async {
    try {
      await InternetAddress.lookup('example.com');
    } on SocketException catch (_) {
      showDialog(
        context: context,
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
                    Text(AppLocalizations.of(context)!.conectApp),
                    const SizedBox(height: 20),
                    RawMaterialButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    final UserCommercialProvider userProvider = Provider.of<UserCommercialProvider>(context);
    final NotificationsProvider notify = Provider.of<NotificationsProvider>(context , listen: false);
    auth.getToken();
    userProvider.getUserData();
    notify.getNotifications(locale: Lang.of(context).localeName);
    return const LandingWrapper();
  }
}
