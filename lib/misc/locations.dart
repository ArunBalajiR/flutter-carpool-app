import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  LatLng latlngPosition;
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latlngPosition = LatLng(position.latitude,position.longitude);


    } catch (e) {
      print(e);
    }
  }
}
