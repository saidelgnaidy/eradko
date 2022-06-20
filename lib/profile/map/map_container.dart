import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class MapControl extends StatefulWidget {
  final LatLng? initPosition ;
  final Function changePos ;
  const MapControl({Key? key, this.initPosition, required this.changePos}) : super(key: key);

  @override
  State<MapControl> createState() => _MapControlState();
}

class _MapControlState extends State<MapControl> {
  final Completer<GoogleMapController> _controller = Completer();
  late Marker myMarker ;
  late CameraPosition _myLocation  ;


  markNewLocation(latLong){
    setState(() {
      myMarker =  Marker(
        markerId: const MarkerId( 'currentLocation') ,
        position: LatLng(latLong.latitude , latLong.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow:   const InfoWindow(title: 'Selected Location'),
      );
    });
  }

  @override
  void initState() {
    _myLocation  =  CameraPosition(
      target: widget.initPosition ??  const LatLng(24.774265, 46.738586),
      zoom: 14.4746,
    );
    myMarker =  Marker(
      markerId: const MarkerId( 'currentLocation') ,
      position: widget.initPosition ??  const LatLng(24.774265, 46.738586),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow:   const InfoWindow(title: 'Your Current Location'),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: widget.initPosition != null ? GoogleMap(
            mapType: MapType.normal,
            onTap: (LatLng latLng) {
              markNewLocation(latLng);
              widget.changePos(latLng);
            } ,
            zoomControlsEnabled: false,
            initialCameraPosition: _myLocation,
            myLocationEnabled: true,
            markers: {
              myMarker
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ): Center(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:   [
                Text( AppLocalizations.of(context)!.loadYourSite) ,
                const CircularProgressIndicator()
              ],
            ),
          ) ,
        ),
      ),
    );
  }

}

