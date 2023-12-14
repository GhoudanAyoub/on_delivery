import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? pass;
  String? type;
  String? firstName;
  String? lastname;
  String? city;
  String? phone;
  String? photoUrl;
  String? verificationType;
  String? side1PhotoUrl;
  String? side2PhotoUrl;
  String? passportPhotoUrl;
  String? businessType;
  String? businessName;
  String? transportType;
  String? wareHouse;
  String? activities;
  String? verified;
  List<dynamic>? agentTripsLocationList;
  List<dynamic>? wareHouseLocationList;
  String? percentage;
  String? maxWeight;
  String? unity;
  String? price;
  String? RIB;
  String? bankName;
  Timestamp? signedUpAt;
  Timestamp? lastSeen;
  bool? isOnline;
  bool? enable;
  double? Lnt;
  double? Lng;

  UserModel(
      {this.id,
      this.email,
      this.pass,
      this.type,
      this.firstName,
      this.lastname,
      this.city,
      this.phone,
      this.photoUrl,
      this.verificationType,
      this.businessType,
      this.businessName,
      this.transportType,
      this.wareHouse,
      this.activities,
      this.agentTripsLocationList,
      this.wareHouseLocationList,
      this.maxWeight,
      this.percentage,
      this.unity,
      this.price,
      this.verified,
      this.RIB,
      this.bankName,
      this.signedUpAt,
      this.lastSeen,
      this.isOnline,
      this.Lnt,
      this.Lng,
      this.enable});

  UserModel.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    email = json['email'];
    pass = json['pass'];
    type = json['type'];
    firstName = json['firstName'];
    lastname = json['lastName'];
    city = json['city'];
    phone = json['phone'];
    photoUrl = json['photoUrl'];
    verificationType = json['verificationType'];
    side1PhotoUrl = json['side1PhotoUrl'];
    side2PhotoUrl = json['side2PhotoUrl'];
    passportPhotoUrl = json['passportPhotoUrl'];
    businessType = json['businessType'];
    businessName = json['businessName'];
    transportType = json['transportType'];
    wareHouse = json['wareHouse'];
    activities = json['activities'];
    agentTripsLocationList = json['agentTripsLocationList'];
    wareHouseLocationList = json['wareHouseLocationList'];
    maxWeight = json['maxWeight'];
    percentage = json['percentage'];
    unity = json['unity'];
    price = json['price'];
    verified = json['verified'];
    RIB = json['RIB'];
    bankName = json['bankName'];
    signedUpAt = json['signedUpAt'];
    lastSeen = json['lastSeen'];
    isOnline = json['isOnline'];
    Lnt = json['Lnt'];
    Lng = json['Lng'];
    enable = json['enable'];
  }

  Map<String?, dynamic> toJson() {
    final HashMap<String?, dynamic> data = new HashMap<String?, dynamic>();
    data.putIfAbsent('id', () => this.id);
    data['email'] = this.email;
    data['pass'] = this.pass;
    data['type'] = this.type;
    data['firstName'] = this.firstName;
    data['lastname'] = this.lastname;
    data['city'] = this.city;
    data['phone'] = this.phone;
    data['photoUrl'] = this.photoUrl;
    data['verificationType'] = this.verificationType;
    data['side1PhotoUrl'] = this.side1PhotoUrl;
    data['side2PhotoUrl'] = this.side2PhotoUrl;
    data['passportPhotoUrl'] = this.passportPhotoUrl;
    data['businessType'] = this.businessType;
    data['businessName'] = this.businessName;
    data['transportType'] = this.transportType;
    data['wareHouse'] = this.wareHouse;
    data['activities'] = this.activities;
    data['agentTripsLocationList'] = this.agentTripsLocationList;
    data['wareHouseLocationList'] = this.wareHouseLocationList;
    data['maxWeight'] = this.maxWeight;
    data['percentage'] = this.percentage;
    data['unity'] = this.unity;
    data['price'] = this.price;
    data['RIB'] = this.RIB;
    data['bankName'] = this.bankName;
    data['verified'] = this.verified;
    data['signedUpAt'] = this.signedUpAt;
    data['lastSeen'] = this.lastSeen;
    data['isOnline'] = this.isOnline;
    return data;
  }
}
