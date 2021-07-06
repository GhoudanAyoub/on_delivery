class AgentLocation {
  double Lnt;
  double Lng;

  AgentLocation({this.Lnt, this.Lng});

  AgentLocation.fromJson(Map<String, dynamic> json) {
    Lnt = json['Lnt'];
    Lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Lnt'] = this.Lnt;
    data['Lng'] = this.Lng;
    return data;
  }
}
