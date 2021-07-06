class Orders {
  String startAt;
  String endAt;
  String userId;
  String agentId;
  String price;
  String status;
  String date;

  Orders(
      {this.startAt,
      this.endAt,
      this.userId,
      this.agentId,
      this.price,
      this.status,
      this.date});

  Orders.fromJson(Map<String, dynamic> json) {
    startAt = json['startAt'];
    endAt = json['endAt'];
    userId = json['userId'];
    agentId = json['agentId'];
    price = json['price'];
    status = json['status'];
    date = json['date'];
  }
}
