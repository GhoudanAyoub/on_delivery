import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/components/text_time.dart';
import 'package:on_delivery/models/enum/message_type.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatefulWidget {
  final String message;
  final MessageType type;
  final Timestamp time;
  final bool isMe;
  final bool accepted;

  ChatBubble({
    @required this.message,
    @required this.time,
    @required this.isMe,
    @required this.type,
    this.accepted,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  Color chatBubbleColor() {
    if (widget.isMe) {
      return Color.fromRGBO(248, 250, 251, 1);
    } else {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.grey[800];
      } else {
        return Colors.grey[200];
      }
    }
  }

  Color chatBubbleReplyColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey[600];
    } else {
      return Colors.grey[50];
    }
  }

  @override
  Widget build(BuildContext context) {
    final align =
        !widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = widget.isMe
        ? BorderRadius.only(
            topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0))
        : BorderRadius.only(
            topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0));
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: chatBubbleColor(),
            borderRadius: radius,
          ),
          constraints: BoxConstraints(
            maxWidth: 280,
            minWidth: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.all(widget.type == MessageType.TEXT ? 10 : 0),
                child: widget.type == MessageType.TEXT
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.message,
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.8,
                                color: widget.message
                                        .toLowerCase()
                                        .contains("please confirm you position")
                                    ? Color.fromRGBO(45, 111, 214, 1)
                                    : Color.fromRGBO(10, 22, 41, 1),
                                decoration: widget.message
                                        .toLowerCase()
                                        .contains("please confirm you position")
                                    ? TextDecoration.underline
                                    : TextDecoration.none),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          widget.accepted == true
                              ? Text(
                                  "Order declined",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.8,
                                    color: Color.fromRGBO(238, 71, 0, 1),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                        ],
                      )
                    : CachedNetworkImage(
                        imageUrl: "${widget.message}",
                        height: 200,
                        width: MediaQuery.of(context).size.width / 1.3,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        ),
        Padding(
          padding: widget.isMe
              ? EdgeInsets.only(
                  right: 10.0,
                  bottom: 10.0,
                )
              : EdgeInsets.only(
                  left: 10.0,
                  bottom: 10.0,
                ),
          child: TextTime(
            child: Text(
              timeago.format(widget.time.toDate()),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
