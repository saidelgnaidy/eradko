import 'package:eradko/commercial_id/user_cmmercial_provider.dart';
import 'package:eradko/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


showNeedCommercialDialog(BuildContext context) {

  showDialog(
    context: context,
    builder: (context){
      return StatefulBuilder(
      builder: (context , setState) {
        final UserCommercialProvider commercialProvider = Provider.of<UserCommercialProvider>(context);
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/sec_clear.png',width: 150,),
                  Center(child: Text(Lang.of(context).addCommercial ,textAlign: TextAlign.center,)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RawMaterialButton(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        onPressed: commercialProvider.isLoading ?null: () {
                          commercialProvider.uploadId();
                        },
                        shape: const StadiumBorder(),
                        fillColor: accentColor,
                        child: commercialProvider.isLoading? jumpingDots(): Text(
                          Lang.of(context).add,
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                      RawMaterialButton(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        onPressed: commercialProvider.isLoading ?null:() {
                          commercialProvider.setUploadMsg('');
                          Navigator.pop(context);
                        },
                        shape: const StadiumBorder(),
                        fillColor: accentColor,
                        child: Text(
                          Lang.of(context).back,
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    commercialProvider.uploadMsg ,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ],
              )
            ],
          );
        }
      );
    },
  );
}


jumpingDots(){
  return const SizedBox(width: 20,height: 20, child: Center(child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Colors.white),
  )));
}

