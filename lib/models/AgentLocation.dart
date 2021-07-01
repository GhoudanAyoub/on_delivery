class AgentLocation {
  String id;
  double Lnt;
  double Lng;
  String displayName;

  AgentLocation({this.id, this.Lnt, this.Lng, this.displayName});

  AgentLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    Lnt = json['Lnt'];
    Lng = json['Lng'];
    displayName = json['displayName'];
  }
}
