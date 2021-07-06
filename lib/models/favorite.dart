class FavoriteModel {
  String clientId;
  dynamic agentData;

  FavoriteModel({this.clientId, this.agentData});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    agentData = json['agentData'];
  }
}
