import 'package:eradko/profile/adresses_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/const.dart';
import 'package:eradko/profile/add_new_address.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MyAddresses extends StatefulWidget {
  const MyAddresses({Key? key}) : super(key: key);

  @override
  State<MyAddresses> createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses>  with AutomaticKeepAliveClientMixin{


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AddressesProvider addressesProvider = Provider.of<AddressesProvider>(context);
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<UserAddress>>(
            future: addressesProvider.getAddresses(notify: false),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: addressesProvider.getUserAddresses.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20 , vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: accentDeActive , width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(addressesProvider.getUserAddresses[index].city ,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(addressesProvider.getUserAddresses[index].area ,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(addressesProvider.getUserAddresses[index].nearestPlace ,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(addressesProvider.getUserAddresses[index].street,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(addressesProvider.getUserAddresses[index].phone ,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: ( ){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewAddress(
                                  isUpdate: true,
                                  userAddress: addressesProvider.getUserAddresses[index],
                                )));
                              },
                                icon: const Icon(Icons.edit,color: Colors.grey,),
                              ),
                              const SizedBox(height: 20),
                              IconButton(onPressed: ( ){
                                setState(() {
                                  AddressesProvider().deleteAddress( addressesProvider.getUserAddresses[index].id.toString()) .then((value) {
                                    showSnackError(context, msg: value);
                                  });
                                  addressesProvider.getUserAddresses.removeAt(index);
                                });
                              },
                                icon: const Icon(Icons.delete,color: Colors.red,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }else{
                return const Center(child: CircularProgressIndicator());
              }
            }
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 20, 40, 40),
          width: double.infinity,
          height: 45,
          child: RawMaterialButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewAddress(
                isUpdate: false,
                userAddress: UserAddress(id: 00, phone: '', street: '', area: '', nearestPlace: '', cityId: 00, city: '', lang: '', lat: ''),
              )));
            },
            fillColor: accentColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Text(AppLocalizations.of(context)!.addNewAddress,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
