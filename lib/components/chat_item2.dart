import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/enum/message_type.dart';
import 'package:on_delivery/utils/firebase.dart';

class ChatItem2 extends StatelessWidget {
  final String? userId;
  final Timestamp time;
  final String? msg;
  final int messageCount;
  final String? chatId;
  final MessageType type;
  final String? currentUserId;
  final bool isAgent;
  final VoidCallback onTap;

  ChatItem2(
      {Key? key,
      required this.userId,
      required this.time,
      required this.msg,
      required this.messageCount,
      required this.chatId,
      required this.type,
      required this.currentUserId,
      this.isAgent = false,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRef.doc('$userId').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot? documentSnapshot =
              snapshot.data as DocumentSnapshot?;
          Map<String?, dynamic>? mapData = documentSnapshot?.data();
          if (snapshot.hasData && mapData != null) {
            UserModel user = UserModel.fromJson(mapData);

            return GestureDetector(
              child: SizedBox(
                height: 40,
                width: 40,
                child: Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        '${user?.photoUrl}',
                      ),
                      radius: 25.0,
                    ),
                    Positioned(
                      right: -5,
                      bottom: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        height: 15,
                        width: 15,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: user?.isOnline ?? false
                                  ? Color(0xff00d72f)
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            height: 11,
                            width: 11,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: onTap,
            );
          } else {
            return SizedBox();
          }
        } else {
          return SizedBox();
        }
      },
    );
  }
}
