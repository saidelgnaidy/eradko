// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/const.dart';
import 'package:eradko/media/articels.dart';
import 'package:eradko/media/releases_view.dart';
import 'package:eradko/media/widgits/reused_wedgits.dart';
import 'package:eradko/profile/my_adresses.dart';
import 'package:eradko/orders/my_orders.dart';
import 'package:eradko/profile/notifications.dart';
import 'package:eradko/profile/user_info.dart';
import 'package:eradko/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'notify/notifications_provider.dart';
import 'package:provider/provider.dart';

class ProfileLanding extends StatefulWidget {
  const ProfileLanding({Key? key}) : super(key: key);

  @override
  _ProfileLandingState createState() => _ProfileLandingState();
}

class _ProfileLandingState extends State<ProfileLanding>
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

    final NotificationsProvider notify = Provider.of<NotificationsProvider>(context);

    return  Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Text(AppLocalizations.of(context)!.profile,
                style: TextStyle(color: textColor),
              ),
            ),
            TabBar(
              controller: ctrl,
              indicatorColor: Colors.transparent,
              labelPadding: EdgeInsets.symmetric(horizontal: 3),
              padding: EdgeInsets.symmetric(horizontal: 10),
              tabs: [
                MediaBarItem(
                  active: currentIndex == 0,
                  title: AppLocalizations.of(context)!.myInfo,
                ),
                MediaBarItem(
                  active: currentIndex == 1,
                  title:AppLocalizations.of(context)!.myOrders,
                ),
                MediaBarItem(
                  active: currentIndex == 2,
                  title:AppLocalizations.of(context)!.myAddress,
                ),
                Stack(
                  children: [
                    MediaBarItem(
                      active: currentIndex == 3,
                      title: AppLocalizations.of(context)!.myNotification,
                    ),
                    !notify.allSeen ?
                    Positioned(
                      top: 2,
                      right: 3,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color:  Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ):SizedBox(),
                  ],
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: ctrl,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  UserInformation(),
                  MyOrders(),
                  MyAddresses(),
                  NotificationsView(),
                ],
              ),
            ),
          ],
        ),

    );
  }
}

