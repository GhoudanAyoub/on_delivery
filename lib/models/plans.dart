class PlansModel {
  String startAt;
  String endAt;
  String userId;
  String planType;

  PlansModel({this.startAt, this.endAt, this.userId, this.planType});

  PlansModel.fromJson(Map<String, dynamic> json) {
    startAt = json['startAt'];
    endAt = json['endAt'];
    userId = json['userId'];
    planType = json['planType'];
  }
}
