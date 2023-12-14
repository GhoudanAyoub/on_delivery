import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/components/chat_item.dart';
import 'package:on_delivery/components/chat_item2.dart';
import 'package:on_delivery/home/base.dart';
import 'package:on_delivery/models/enum/message_type.dart';
import 'package:on_delivery/models/new_message_system.dart';
import 'package:on_delivery/utils/constants.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

import 'conversation.dart';

class Chats extends StatefulWidget with NavigationStates {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List chatList = [];
  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel =
        Provider.of<UserViewModel>(context, listen: false);
    viewModel.setUser();
    viewModel.setType();
    return Scaffold(
        body: new WillPopScope(
            onWillPop: () async {
              Navigator.pushNamed(context, Base.routeName);
              return true;
            },
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('assets/images/pg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 80, bottom: 5),
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: userChatsStream(
                              '${firebaseAuth.currentUser.uid}'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              chatList.clear();
                              for (DocumentSnapshot doc
                                  in snapshot.data!.documents) {
                                if (doc.data()['users'][0].toString().contains(
                                        firebaseAuth.currentUser.uid) ||
                                    doc.data()['users'][1].toString().contains(
                                        firebaseAuth.currentUser.uid)) {
                                  chatList.add(doc);
                                }
                              }
                              if (chatList.isNotEmpty) {
                                return Expanded(
                                    child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Agents',
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        height: 60,
                                        child: ListView.builder(
                                          itemCount: chatList.length,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            DocumentSnapshot chatListSnapshot =
                                                chatList[index];
                                            return StreamBuilder<QuerySnapshot>(
                                              stream: messageListStream(
                                                  chatListSnapshot.id),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  List messages =
                                                      snapshot.data!.docs;
                                                  Message message =
                                                      Message.fromJson(messages
                                                          .first
                                                          .data());
                                                  List users = chatListSnapshot
                                                      .data()['users'];
                                                  users.remove(
                                                      '${viewModel.user?.uid ?? ""}');
                                                  String? recipient = users[0];
                                                  return Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 5.0),
                                                    child: ChatItem2(
                                                      onTap: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Conversation(
                                                                userId:
                                                                    recipient,
                                                                chatId:
                                                                    chatListSnapshot
                                                                        .id,
                                                                isAgent: viewModel
                                                                        .type
                                                                        ?.toLowerCase()
                                                                        .contains(
                                                                            "agent")==true
                                                                    ? true
                                                                    : false,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      userId: recipient,
                                                      messageCount: messages.length??0,
                                                      msg: message.content,
                                                      time: message.time??Timestamp.now(),
                                                      chatId: chatListSnapshot.id,
                                                      type: message.type??MessageType.TEXT,
                                                      currentUserId:
                                                          viewModel.user?.uid ??
                                                              "",
                                                      isAgent: viewModel.type
                                                              ?.toLowerCase()
                                                              .contains("agent")==true
                                                          ? true
                                                          : false,
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              },
                                            );
                                          },
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Conversations',
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                              foreground: Paint()
                                                ..shader = greenLinearGradient),
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      itemCount: chatList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DocumentSnapshot chatListSnapshot =
                                            chatList[index];
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: messageListStream(
                                              chatListSnapshot.id),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List messages =
                                                  snapshot.data!.documents;
                                              Message message =
                                                  Message.fromJson(
                                                      messages.first.data());
                                              List users = chatListSnapshot
                                                  .data()['users'];
                                              users.remove(
                                                  '${viewModel.user?.uid ?? ""}');
                                              String? recipient = users[0];
                                              return ChatItem(
                                                userId: recipient,
                                                messageCount: messages.length??0,
                                                msg: message.content,
                                                time: message.time??Timestamp.now(),
                                                chatId: chatListSnapshot.id,
                                                type: message.type??MessageType.TEXT,
                                                currentUserId:
                                                    viewModel.user.uid ?? "",
                                                isAgent: viewModel.type
                                                        ?.toLowerCase()
                                                        .contains("agent")==true
                                                    ? true
                                                    : false,
                                              );
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        );
                                      },
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ));
                              } else {
                                return Expanded(
                                  child: Column(
                                    children: [
                                      Center(
                                          child: Lottie.asset(
                                              'assets/lotties/chat_not_ready.json')),
                                      Text("No Chat For The Moments",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: IconButton(
                                          icon: Icon(
                                            CupertinoIcons.backward,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, Base.routeName);
                                          },
                                        )

                                        /*Container(
                                          height: 60.0,
                                          width:
                                              getProportionateScreenWidth(200),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color.fromRGBO(
                                                      82, 238, 79, 1),
                                                  Color.fromRGBO(5, 151, 0, 1)
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[500]??Colors.grey,
                                                  offset: Offset(0.0, 1.5),
                                                  blurRadius: 1.5,
                                                ),
                                              ]),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: () async {
                                                  Navigator.pushNamed(
                                                      context, Base.routeName);
                                                },
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Return',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        )*/
                                        ,
                                      )
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return Expanded(
                                child: Center(
                                    child: Lottie.asset(
                                        'assets/lotties/empty_chat.json')),
                              );
                            }
                          }),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          width: 135,
                          height: 5,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[Colors.grey, Colors.grey],
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[500]??Colors.grey,
                                  offset: Offset(0.0, 1.5),
                                  blurRadius: 1.5,
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  Stream<QuerySnapshot> userChatsStream(String? uid) {
    return chatRef.orderBy("lastTextTime", descending: true).snapshots();
  }

  Stream<QuerySnapshot> messageListStream(String? documentId) {
    return chatRef
        .doc(documentId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
