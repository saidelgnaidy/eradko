import 'package:eradko/cart/widget/widget_number_order.dart';
import 'package:eradko/common/app_drawer.dart';
import 'package:eradko/home/home_wraper.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class TakeOrder extends StatelessWidget {
  const TakeOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        drawer: const MyDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image.asset(
                    "assets/image/Group 306.png",
                    height: 130,
                    width: 130,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                    Text(
                    AppLocalizations.of(context)!.takeOrderSuc,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                    Text(
                    AppLocalizations.of(context)!.thanks,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const NumberOrder(),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 60,
                child: TimelineTile(
                  lineXY: 0.2,
                  indicatorStyle: const IndicatorStyle(height: 1.0),
                  alignment: TimelineAlign.manual,
                  endChild: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/image/Group 301.png",
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                          Text(
                          AppLocalizations.of(context)!.takeorder,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
                height: 70,
                child: TimelineTile(
                  lineXY: 0.2,
                  indicatorStyle: const IndicatorStyle(height: 1.0),
                  alignment: TimelineAlign.manual,
                  endChild: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Row(
                        children: [
                          Image.asset(
                            "assets/image/Group 302.png",
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                            Text(
                            AppLocalizations.of(context)!.charged,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      subtitle:   Text(
                        "(1233618945)+ ${AppLocalizations.of(context)!.numbertraking}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                )),
            SizedBox(
                height: 90,
                child: TimelineTile(
                  lineXY: 0.2,
                  indicatorStyle: const IndicatorStyle(height: 1.0),
                  alignment: TimelineAlign.manual,
                  endChild: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/image/Group 303.png",
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                          Text(
                            AppLocalizations.of(context)!.deliverySuccess  ,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  )),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingWrapper(),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child:   Text(
                    AppLocalizations.of(context)!.backHome,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),

    );
  }
}
