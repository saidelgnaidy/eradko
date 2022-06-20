import 'package:eradko/cart/cart.dart';
import 'package:eradko/const.dart';
import 'package:eradko/home/home_wraper.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuccessfulOrder extends StatelessWidget {
  final String orderNumber ;
  final int step ;
  const SuccessfulOrder({Key? key, required this.orderNumber, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context);

    return WillPopScope(
      onWillPop: ()async{
        return false ;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(0, 55),
          child: AppBar(
            backgroundColor: const Color(0xff0e9e59),
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 7.5),
              child: SizedBox(
                height: 40,
                child: Image.asset(
                  'assets/image/logoerad.png',
                ),
              ),
            ),
            leading: const SizedBox(),
            actions: [

              IconButton(
                onPressed: () {
                  routsProvider.topLayerSetter(widget: const Cart(), index: routsProvider.topWidgetIndex , previousIndex: routsProvider.currentIndex, );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const LandingWrapper()), (Route<dynamic> route) => route is LandingWrapper,
                  );
                  },
                icon: const Icon(Icons.shopping_cart_outlined),
              )   ,
            ],
          ),
        )  ,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Image.asset(
                  'assets/image/thanx.png',
                  width: size.width / 2.5,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    Lang.of(context).orderIsSuccessful,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                  ),
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: accentColor.withOpacity(.6),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          Lang.of(context).orderNumber,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          orderNumber,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30 , vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomStep(isActive: step == 1, title: Lang.of(context).takeorder , icon: Icons.thumb_up_rounded,),
                      const SizedBox(height: 50,child: VerticalDivider(width: 24 ,thickness: 2,),),
                      CustomStep(isActive: step == 2, title: Lang.of(context).charged , icon: Icons.cable_rounded,),
                      const SizedBox(height: 50,child: VerticalDivider(width: 24 ,thickness: 2,),),
                      CustomStep(isActive: step == 3, title: Lang.of(context).deliverySuccess , icon: Icons.local_shipping_rounded,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 30),
          child: MaterialButton(
            height: 45,
            color: accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: () {
              routsProvider.topLayerSetter(widget: const SizedBox(), index: 0 , previousIndex: 0, );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const LandingWrapper()), (Route<dynamic> route) => route is LandingWrapper,
              );
            },
            child: Text(
              Lang.of(context).backHome,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomStep extends StatelessWidget {
  final String title ;
  final IconData icon ;
  final bool isActive ;
  const CustomStep({
    Key? key, required this.title, required this.icon, required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle_rounded,color: isActive ? accentColor : textColor,),
        const SizedBox(width: 25),
        Icon(icon,color: isActive ? accentColor : textColor ,),
        const SizedBox(width: 25),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: isActive ? accentColor : textColor,
          ),
        ),
      ],
    );
  }
}
