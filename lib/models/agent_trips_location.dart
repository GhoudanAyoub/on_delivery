class AgentTripsLocation {
  double lnt;
  double lng;
  String startingPoint;
  String arrivalPoint;

  AgentTripsLocation(
      {this.lnt, this.lng, this.startingPoint, this.arrivalPoint});

  static AgentTripsLocation fromJson(Map<String, dynamic> json) =>
      AgentTripsLocation(
        lnt: json['lnt'],
        lng: json['lng'],
        startingPoint: json['startingPoint'],
        arrivalPoint: json['arrivalPoint'],
      );
}
