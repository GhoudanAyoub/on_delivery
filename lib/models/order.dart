import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  GeoPoint startAt;
  GeoPoint endAt;
  String userId;
  String agentId;
  String price;
  String status;
  Timestamp date;
  bool iceBox;
  String brand;
  String transport;
  String maxWeight;
  String numberItem;
  bool lunchStatus;

  Orders(
      {this.startAt,
      this.endAt,
      this.userId,
      this.agentId,
      this.price,
      this.status,
      this.date,
      this.iceBox,
      this.brand,
      this.transport,
      this.maxWeight,
      this.numberItem,
      this.lunchStatus});

  Orders.fromJson(Map<String, dynamic> json) {
    startAt = json['startAt'];
    endAt = json['endAt'];
    userId = json['userId'];
    agentId = json['agentId'];
    price = json['price'];
    status = json['status'];
    date = json['date'];
    iceBox = json['iceBox'];
    brand = json['brand'];
    transport = json['transport'];
    maxWeight = json['maxWeight'];
    numberItem = json['numberItem'];
    lunchStatus = json['lunchStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startAt'] = this.startAt;
    data['endAt'] = this.endAt;
    data['userId'] = this.userId;
    data['agentId'] = this.agentId;
    data['price'] = this.price;
    data['status'] = this.status;
    data['date'] = this.date;
    data['iceBox'] = this.iceBox;
    data['brand'] = this.brand;
    data['transport'] = this.transport;
    data['maxWeight'] = this.maxWeight;
    data['numberItem'] = this.numberItem;
    data['lunchStatus'] = this.lunchStatus;
    return data;
  }
}

class OrderContainer {
  dynamic orderData;

  OrderContainer({this.orderData});

  OrderContainer.fromJson(Map<String, dynamic> json) {
    orderData = json['orderData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderData'] = this.orderData;
    return data;
  }
}
