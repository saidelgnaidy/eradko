import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/cart/cart.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:eradko/profile/empty_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

buildAppBar(context , {required bool showCart , bool needPop = false}) {
 final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context);
 final AuthProvider auth = Provider.of<AuthProvider>(context,listen: false);

  return PreferredSize(
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
      actions: [
        showCart ?
        IconButton(
          onPressed: () {
            if(auth.token != 'null'){
              if(needPop){
                Navigator.pop(context);
                routsProvider.topLayerSetter(widget: const Cart(), index: routsProvider.topWidgetIndex , previousIndex: routsProvider.currentIndex, );
              }else{
                routsProvider.topLayerSetter(widget: const Cart(), index: routsProvider.topWidgetIndex , previousIndex: routsProvider.currentIndex, );
              }
            }else{
              showNotLoggedInDialog(context);
            }

          },
          icon: const Icon(Icons.shopping_cart_outlined),
        ): const SizedBox()    ,
      ],
    ),
  );
}
