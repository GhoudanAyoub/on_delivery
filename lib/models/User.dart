import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class UserModel {
  String email;
  String pass;
  String type;
  String firstName;
  String lastname;
  String city;
  String phone;
  String photoUrl;
  String verificationType;
  String businessType;
  String businessName;
  String transportType;
  String wareHouse;
  String wareHouseAddress;
  Position wareHousePosition;
  String RIB;
  String bankName;
  Timestamp signedUpAt;
  Timestamp lastSeen;
  bool isOnline;

  UserModel(
      {this.email,
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
      this.wareHouseAddress,
      this.wareHousePosition,
      this.RIB,
      this.bankName,
      this.signedUpAt,
      this.lastSeen,
      this.isOnline});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    pass = json['pass'];
    type = json['type'];
    firstName = json['firstName'];
    lastname = json['lastname'];
    city = json['city'];
    phone = json['phone'];
    photoUrl = json['photoUrl'];
    verificationType = json['verificationType'];
    businessType = json['businessType'];
    businessName = json['businessName'];
    transportType = json['transportType'];
    wareHouse = json['wareHouse'];
    wareHouseAddress = json['wareHouseAddress'];
    wareHousePosition = json['wareHousePosition'];
    RIB = json['RIB'];
    bankName = json['bankName'];
    signedUpAt = json['signedUpAt'];
    lastSeen = json['lastSeen'];
    isOnline = json['isOnline'];
  }
}
