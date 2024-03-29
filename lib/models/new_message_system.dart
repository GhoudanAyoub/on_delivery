import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/enum/message_type.dart';

class Message {
  String? content;
  String? senderUid;
  MessageType? type;
  int? stages = 1;
  Timestamp? time;

  Message({this.content, this.senderUid, this.type, this.time, this.stages});

  Message.fromJson(Map<String?, dynamic> json) {
    content = json['content'];
    senderUid = json['senderUid'];
    if (json['type'] == 'text') {
      type = MessageType.TEXT;
    } else {
      type = MessageType.IMAGE;
    }
    time = json['time'];
    stages = json['stages'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['content'] = this.content;
    data['senderUid'] = this.senderUid;
    if (this.type == MessageType.TEXT) {
      data['type'] = 'text';
    } else {
      data['type'] = 'image';
    }
    data['time'] = this.time;
    data['stages'] = this.stages;
    return data;
  }
}
