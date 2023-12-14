import 'package:cloud_firestore/cloud_firestore.dart';

class AgentTripsLocation {
  late String? startingPointString;
  late String? arrivalPointString;
  late GeoPoint? startingPoint;
  late GeoPoint? arrivalPoint;

  AgentTripsLocation(
      {required this.startingPointString,
      required this.arrivalPointString,
      required this.startingPoint,
      required this.arrivalPoint});

  static AgentTripsLocation fromJson(Map<String?, dynamic> json) =>
      AgentTripsLocation(
        startingPointString: json['startingPointString'],
        arrivalPointString: json['arrivalPointString'],
        startingPoint: json['startingPoint'],
        arrivalPoint: json['arrivalPoint'],
      );
}
