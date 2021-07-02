import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  double lnt;
  double lng;
  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.lnt = position.latitude;
      this.lng = position.longitude;
      notifyListeners();
    } else {
      debugPrint("Permission not allowed");
    }
  }
}
