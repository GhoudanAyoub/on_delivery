import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/utils/firebase.dart';

class LocationService with ChangeNotifier {
  bool permissionGranted = false;
  var selectedAddress;
  static final String? TAG = "LocationService";
  static int UPDATE_INTERVAL = 4 * 1000; /* 4 secs */
  static int FASTEST_INTERVAL = 2000; /* 2 sec */

  late double lnt;
  late double lng;
  late Location location;

  late UserModel agentLocation;
  late StreamController<UserModel> _streamController;

  LocationService() {
    location = new Location();
    _streamController = StreamController<UserModel>.broadcast();

    location.requestPermission().then((value) => {
          if (value != null)
            {
              location.onLocationChanged.listen((event) {
                if (event != null) {
                  _streamController.add(
                      UserModel(Lnt: event.latitude, Lng: event.longitude));
                  updateLocationToFirebase(event.latitude, event.longitude);
                }
              })
            }
        });
  }

  Future<String?> getCurrentCoordinatesName(lnts, lngs) async {
    final coordinates = new Coordinates(lnts, lngs);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectedAddress = addresses.first;
    return addresses.first.addressLine;
  }

  updateLocationToFirebase(latitude, longitude) async {
    if (firebaseAuth.currentUser != null) {
      final snapShot = await usersRef.doc(firebaseAuth.currentUser.uid).get();
      if (snapShot.exists) {
        usersRef.doc(firebaseAuth.currentUser.uid).update({
          'Lnt': latitude,
          'Lng': longitude,
        });
      } else
        usersRef.doc(firebaseAuth.currentUser.uid).set({
          'Lnt': latitude,
          'Lng': longitude,
        });
    }
  }

  Stream<UserModel> get locationStream => _streamController.stream;

  Future<UserModel> getCurrentPosition() async {
    var position = await location.getLocation();

    if (position != null) {
      this.lnt = position.latitude;
      this.lng = position.longitude;
      this.permissionGranted = true;
      agentLocation = UserModel(Lng: lng, Lnt: lnt);
      notifyListeners();
    } else {
      debugPrint("Permission not allowed");
    }
    return agentLocation;
  }
}
