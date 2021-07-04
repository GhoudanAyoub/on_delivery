import 'package:cloud_firestore/cloud_firestore.dart';

class AgentTripsLocation {
  String startingPointString;
  String arrivalPointString;
  GeoPoint startingPoint;
  GeoPoint arrivalPoint;

  AgentTripsLocation(
      {this.startingPointString,
      this.arrivalPointString,
      this.startingPoint,
      this.arrivalPoint});

  static AgentTripsLocation fromJson(Map<String, dynamic> json) =>
      AgentTripsLocation(
        startingPointString: json['startingPointString'],
        arrivalPointString: json['arrivalPointString'],
        startingPoint: json['startingPoint'],
        arrivalPoint: json['arrivalPoint'],
      );
}
