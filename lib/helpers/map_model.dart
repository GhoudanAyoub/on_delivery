import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyModel extends ChangeNotifier {
  String name = "";
  String adr = "";
  Future<List> value;
  bool _showInfoWindow = false;
  bool _tempHidden = false;

  void rebuildInfoWindow() {
    notifyListeners();
  }

  void updateVisibility(bool visibility) {
    _showInfoWindow = visibility;
  }

  void updateInfoWindow(
      BuildContext context,
      GoogleMapController controller,
      LatLng location,
      double infoWindowWidth,
      double markerOffset,
      String name,
      String Adr) async {
    name = name;
    adr = Adr;
    ScreenCoordinate screenCoordinate =
        await controller.getScreenCoordinate(location);
    double devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) -
        (infoWindowWidth / 2);
    double top =
        (screenCoordinate.y.toDouble() / devicePixelRatio) - markerOffset;
    if (left < 1 || top < 1) {
      _tempHidden = true;
    } else {
      _tempHidden = false;
    }
  }

  bool get showInfoWindow =>
      (_showInfoWindow == true && _tempHidden == false) ? true : false;

  String get Placename => name;
  String get Placeadr => adr;
}
