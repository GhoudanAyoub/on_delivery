import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class UserModel {
  String id;
  String email;
  String pass;
  String type;
  String firstName;
  String lastname;
  String city;
  String phone;
  String photoUrl;
  String verificationType;
  String side1PhotoUrl;
  String side2PhotoUrl;
  String passportPhotoUrl;
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
      this.wareHouseAddress,
      this.wareHousePosition,
      this.RIB,
      this.bankName,
      this.signedUpAt,
      this.lastSeen,
      this.isOnline});

  UserModel.fromJson(Map<String, dynamic> json) {
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
    wareHouseAddress = json['wareHouseAddress'];
    wareHousePosition = json['wareHousePosition'];
    RIB = json['RIB'];
    bankName = json['bankName'];
    signedUpAt = json['signedUpAt'];
    lastSeen = json['lastSeen'];
    isOnline = json['isOnline'];
  }
}
