import 'package:eradko/common/app_drawer.dart';
import 'package:eradko/const.dart';
import 'package:eradko/navigations/routs_provider.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'branches_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
class BranchesHome extends StatelessWidget {
  const BranchesHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RoutsProvider routsProvider = Provider.of<RoutsProvider>(context , listen: false);

    return WillPopScope(
      onWillPop: () async {
        routsProvider.topLayerSetter(widget: const SizedBox(), index: routsProvider.previousIndex , previousIndex: routsProvider.previousIndex );
        return false ;
      },
      child: Scaffold(
        drawer: const MyDrawer(),
        body: FutureBuilder<List<Branches>>(
            future: BranchesProvider().getBranches(locale:AppLocalizations.of(context)!.localeName),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: accentDeActive, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                snapshot.data![index].title,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  snapshot.data![index].email,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.alternate_email_outlined,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  snapshot.data![index].fax,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  snapshot.data![index].phone,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_city,
                                  color: Colors.brown,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  snapshot.data![index].address,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              }else{
                return LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(accentColor),
                  backgroundColor: Colors.white,
                );
              }
            }
            ),
        floatingActionButtonLocation:AppLocalizations.of(context)!.localeName =='ar' ?  FloatingActionButtonLocation.startFloat :  FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: accentColor,
          child: Icon(AppLocalizations.of(context)!.localeName =='ar' ? Icons.arrow_back : Icons.arrow_forward),
          onPressed: (){
            routsProvider.topLayerSetter(widget: const SizedBox(), index: routsProvider.previousIndex ,
                previousIndex: routsProvider.lastNavIndex );
          },
        ),
      ),
    );
  }
}
