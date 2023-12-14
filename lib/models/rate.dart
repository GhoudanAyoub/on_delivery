import 'package:cloud_firestore/cloud_firestore.dart';

class RateModel {
  String? userID;
  String? agentId;
  double? rate;
  String? rateTxt;
  Timestamp? timestamp;

  RateModel(
      {this.userID, this.agentId, this.rate, this.rateTxt, this.timestamp});
  RateModel.fromJson(Map<String?, dynamic> json) {
    userID = json['userID'];
    agentId = json['agentId'];
    rate = json['rate'];
    rateTxt = json['rateTxt'];
    timestamp = json['timestamp'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['userID'] = this.userID;
    data['agentId'] = this.agentId;
    data['rate'] = this.rate;
    data['rateTxt'] = this.rateTxt;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
