import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  double lnt;
  double lng;
  bool permissionGranted = false;
  var selectedAddress;
  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (position != null) {
      this.lnt = position.latitude;
      this.lng = position.longitude;
      this.permissionGranted = true;
      notifyListeners();
    } else {
      debugPrint("Permission not allowed");
    }
  }

  Future<void> requestPermission() async {
    await Geolocator.requestPermission();
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.lnt = cameraPosition.target.latitude;
    this.lng = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<String> getMoveCamera() async {
    final coordinates = new Coordinates(this.lnt, this.lng);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectedAddress = addresses.first;
    return addresses.first.addressLine;
  }
}
