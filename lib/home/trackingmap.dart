import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:on_delivery/components/order_layout.dart';
import 'package:on_delivery/helpers/direction_repo.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/direction_model.dart';
import 'package:on_delivery/models/order.dart';
import 'package:provider/provider.dart';

class TrackingMap extends StatefulWidget {
  static String routeName = "/TrackingMap";
  final Orders orders;
  final UserModel userModel;

  const TrackingMap({Key key, this.orders, this.userModel}) : super(key: key);
  @override
  _TrackingMapState createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  LatLng currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  static CameraPosition _myPosition;
  LocationProvider locationData;
  UserModel locationService;
  CameraPosition initialLocation;
  Directions _info;
  void updateMarkerAndCircle(LatLng newLocalData) {
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("ME"),
          position: newLocalData,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon:
              BitmapDescriptor.fromAsset("assets/images/mylocationmarker.png"));
      circle = Circle(
          circleId: CircleId("MyCircle"),
          zIndex: 4,
          strokeColor: Colors.green,
          center: newLocalData,
          fillColor: Colors.green.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(LatLng(location.latitude, location.longitude));
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void initState() {
    getCurrentLocation();

    super.initState();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context);
    locationService = Provider.of<UserModel>(context);
    setState(() {
      currentLocation = LatLng(locationService.Lnt, locationService.Lng);
    });

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition:
                  CameraPosition(target: currentLocation, zoom: 1),
              markers: Set.of((marker != null) ? [marker] : []),
              circles: Set.of((circle != null) ? [circle] : []),
              zoomControlsEnabled: true,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: true,
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _info.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
              onCameraMove: (CameraPosition positon) {
                locationData.onCameraMove(positon);
              },
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                _mapController = controller;

                // Get directions
                final directions = await DirectionsRepository().getDirections(
                    origin: LatLng(widget.orders.startAt.latitude,
                        widget.orders.startAt.longitude),
                    destination: LatLng(widget.orders.endAt.latitude,
                        widget.orders.endAt.longitude));
                setState(() {
                  _info = directions;
                  initialLocation = CameraPosition(
                      target: LatLng(locationService.Lnt, locationService.Lng));
                });
              },
            ),
          ),
          /* StreamBuilder(
          stream: usersRef.doc(widget.userModel.id).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              UserModel user1 = UserModel.fromJson(snapshot.data.data());

              _mapController.animateCamera(CameraUpdate.newCameraPosition(
                  new CameraPosition(
                      bearing: 192.8334901395799,
                      target: LatLng(user1.Lnt, user1.Lng),
                      tilt: 0,
                      zoom: 18.00)));
              updateMarkerAndCircle(LatLng(user1.Lnt, user1.Lng));
              return Container(
                height: 0,
              );
            }
            return Container(
              height: 0,
            );
          },
        ),*/
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 80, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/images/Back Arrow.png",
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    mini: true,
                    elevation: 8,
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/geolocate me.png"),
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 300,
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
                child: OrderLayout(
                  user: widget.userModel,
                  order: widget.orders,
                  track: false,
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              width: 135,
              height: 5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.grey, Colors.grey],
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(0.0, 1.5),
                      blurRadius: 1.5,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    ));
  }
}
