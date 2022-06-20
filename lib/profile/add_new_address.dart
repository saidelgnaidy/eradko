import 'package:eradko/profile/adresses_provider.dart';
import 'package:eradko/profile/map/map_container.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/common/app_bar.dart';
import 'package:eradko/const.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
class AddNewAddress extends StatefulWidget {
  final UserAddress  userAddress ;
  final bool isUpdate ;

  const AddNewAddress({Key? key, required this.userAddress, required this.isUpdate}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {

  String city  =  '' , completeAllError = '';
  int cityId = 00 ;
  List<String> errors = [];
  bool loading = false ;
  late TextEditingController _streetCtrl, _phoneCtrl  ,_nearestPlaceCtrl,_areaCtrl ;
  LatLng? _latLong ;

  _addAddress({required AddressesProvider addressesProvider}) async {
    setState(() {
      errors = [];
      completeAllError = '' ;
      loading = true ;
    });
    if(_streetCtrl.text != '' && _phoneCtrl.text != '' && _areaCtrl.text != '' && _nearestPlaceCtrl.text != '' && cityId != 00 ){
       await addressesProvider.addNewAddress(
        id: widget.isUpdate ? widget.userAddress.id : null,
        street: _streetCtrl.text,
        phone: _phoneCtrl.text,
        area: _areaCtrl.text,
        nearestPlace: _nearestPlaceCtrl.text,
        cityId: cityId,
        lang:  '${_latLong?.longitude}' ,
        lat:  '${_latLong?.latitude}' ,
      ).then((value) {
        setState(() {
          loading = false ;
          errors = value ;
          completeAllError = '' ;
        });
       });
    }else {
      setState(() {
        loading = false ;
        completeAllError =   AppLocalizations.of(context)!.completFiled ;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error( 'Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    _streetCtrl = TextEditingController(text: widget.userAddress.street);
    _phoneCtrl  = TextEditingController(text: widget.userAddress.phone );
    _nearestPlaceCtrl = TextEditingController(text: widget.userAddress.nearestPlace);
    _areaCtrl = TextEditingController(text: widget.userAddress.area  );
    city  = widget.userAddress.city ;
    cityId = widget.userAddress.cityId ;
    if (widget.userAddress.id == 00) {
      _determinePosition().then((value) {
      if(mounted){
        setState(() {
          _latLong = LatLng(value.latitude , value.longitude) ;
        });
      }
    });
    } else {
      _latLong = LatLng(double.parse(widget.userAddress.lat) , double.parse(widget.userAddress.lang));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final AddressesProvider  addressesProvider = Provider.of<AddressesProvider>(context,listen: true) ;

    return  Scaffold(
      appBar: buildAppBar(context, showCart: false),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            _latLong != null?
            MapControl(
              initPosition: _latLong,
              changePos: (LatLng latLong){
                setState(() {
                  _latLong = latLong ;
                });
              }
            ):
            Center(
              child:  SizedBox(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:   [
                    Text(AppLocalizations.of(context)!.loadYourSite) ,
                    const CircularProgressIndicator()
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:  [
                const SizedBox(height: 15),
                FutureBuilder<List<CityId>>(
                  future: citiesList(context),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color:accentColor.withOpacity(.6), width: 1.5),
                          ),
                          child: DropdownButton<String>(
                            hint: Text( city == '' ? AppLocalizations.of(context)?.localeName == 'en' ? 'City' : 'المدينة'  : city ,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            icon: const SizedBox(),
                            underline: Container(color: Colors.transparent),
                            onChanged: (val){
                              setState(() {
                                city = val! ;
                              });
                              for (var element in snapshot.data!) {
                                if(element.arName == city || element.enName == city ){
                                  cityId = element.id ;
                                }
                              }
                            },

                            items: snapshot.data!.map<DropdownMenuItem<String>>((CityId value) {
                              return DropdownMenuItem<String>(
                                value: AppLocalizations.of(context)!.localeName == 'ar' ? value.arName : value.enName,
                                child: Center(
                                  child: Text(AppLocalizations.of(context)!.localeName == 'ar' ? value.arName : value.enName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                    else {
                      return const SizedBox(height: 50) ;
                    }
                  },
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  obscureText: false ,
                  hintText: AppLocalizations.of(context)!.region,
                  textEditingController: _areaCtrl,
                  onChanged: (val){} ,
                ),
                CustomTextField(
                  obscureText: false ,
                  textEditingController: _streetCtrl,
                  hintText: AppLocalizations.of(context)!.nameStreet,
                  onChanged: (val){} ,
                ),
                CustomTextField(
                  obscureText: false ,
                  textEditingController: _nearestPlaceCtrl,
                  hintText: AppLocalizations.of(context)!.nearestPlace,
                  onChanged: (val){} ,
                ),
                CustomTextField(
                  obscureText: false ,
                  textEditingController: _phoneCtrl,
                  hintText: AppLocalizations.of(context)!.phone,
                  onChanged: (val){},
                ),
                if (completeAllError == '') const SizedBox() else Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Text(completeAllError ,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: errors.map((e){
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(e , style: const TextStyle(color: Colors.red),),
                      )  ;
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              width: double.infinity,
              height: 50,
              child: RawMaterialButton(
                onPressed: ()=> loading ? null : _addAddress(addressesProvider: addressesProvider)   ,
                fillColor: accentColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: loading ?
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),)) :
                Text(AppLocalizations.of(context)!.saveAddress,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

