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
import 'package:on_delivery/utils/firebase.dart';
import 'package:provider/provider.dart';

const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -300;

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
  StreamSubscription _firebaseSubscription;
  Location _locationTracker = Location();
  LatLng currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  static CameraPosition _myPosition;
  LocationProvider locationData;
  UserModel locationService;
  CameraPosition initialLocation;
  Set<Marker> customMarkers = Set<Marker>();
  Set<Circle> customCircle = Set<Circle>();
  Directions _info;
  BitmapDescriptor arrivalpointicon;
  double pinPillPosition = PIN_VISIBLE_POSITION;
  void updateMarkerAndCircle(LatLng newLocalData) {
    this.setState(() {
      customMarkers.add(Marker(
          markerId: MarkerId("ME"),
          position: newLocalData,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromAsset(
              "assets/images/mylocationmarker.png")));
      customCircle.add(Circle(
          circleId: CircleId("MyCircle"),
          zIndex: 4,
          strokeColor: Colors.green,
          center: newLocalData,
          fillColor: Colors.green.withAlpha(70)));
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
    getagentLocation();
    super.initState();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    if (_firebaseSubscription != null) {
      _firebaseSubscription.cancel();
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
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.orders.startAt.latitude,
                      widget.orders.startAt.longitude),
                  zoom: 14),
              markers: customMarkers,
              circles: customCircle,
              zoomControlsEnabled: true,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: true,
              onTap: (LatLng loc) {
                setState(() {
                  this.pinPillPosition = PIN_INVISIBLE_POSITION;
                });
              },
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

                customMarkers.add(Marker(
                    markerId: MarkerId("START"),
                    position: LatLng(widget.orders.startAt.latitude,
                        widget.orders.startAt.longitude),
                    draggable: false,
                    zIndex: 2,
                    infoWindow: InfoWindow(title: "Start Point"),
                    flat: true,
                    anchor: Offset(0.5, 0.5),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen)));
                customCircle.add(Circle(
                    circleId: CircleId("StartCircle"),
                    zIndex: 4,
                    strokeColor: Colors.green,
                    center: LatLng(widget.orders.startAt.latitude,
                        widget.orders.startAt.longitude),
                    fillColor: Colors.green.withAlpha(70)));
                customMarkers.add(Marker(
                    markerId: MarkerId("END"),
                    position: LatLng(widget.orders.endAt.latitude,
                        widget.orders.endAt.longitude),
                    draggable: false,
                    zIndex: 2,
                    infoWindow: InfoWindow(title: "Arrival Point"),
                    flat: true,
                    anchor: Offset(0.5, 0.5),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange)));
                customCircle.add(Circle(
                    circleId: CircleId("END"),
                    zIndex: 4,
                    strokeColor: Colors.orange,
                    center: LatLng(widget.orders.endAt.latitude,
                        widget.orders.endAt.longitude),
                    fillColor: Colors.green.withAlpha(70)));
              },
            ),
          ),
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
          AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: this.pinPillPosition,
              child: Container(
                height: 300,
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
                child: OrderLayout(
                  count: false,
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

  Future<void> getagentLocation() async {
    if (_firebaseSubscription != null) {
      _firebaseSubscription.cancel();
    }

    _firebaseSubscription =
        usersRef.doc(widget.userModel.id).snapshots().listen((event) {
      if (_controller != null) {
        UserModel user1 = UserModel.fromJson(event.data());
        setState(() {
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  target: LatLng(user1.Lnt, user1.Lng), zoom: 14.00)));
          customMarkers.add(Marker(
              markerId: MarkerId("agent"),
              position: LatLng(user1.Lnt, user1.Lng),
              draggable: false,
              zIndex: 2,
              flat: true,
              onTap: () {
                setState(() {
                  this.pinPillPosition = PIN_VISIBLE_POSITION;
                });
              },
              anchor: Offset(0.5, 0.5),
              icon: BitmapDescriptor.fromAsset(
                  "assets/images/agentmaplocation.png")));
          customCircle.add(Circle(
              circleId: CircleId("agentCircle"),
              zIndex: 4,
              strokeColor: Colors.orange,
              center: LatLng(user1.Lnt, user1.Lng),
              fillColor: Colors.orange.withAlpha(70)));
        });
      }
    });
  }
}

class ShowOnMap extends StatefulWidget {
  static String routeName = "/TrackingMap";
  final Orders orders;
  final UserModel userModel;

  const ShowOnMap({Key key, this.orders, this.userModel}) : super(key: key);
  @override
  _ShowOnMapState createState() => _ShowOnMapState();
}

class _ShowOnMapState extends State<ShowOnMap> {
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
