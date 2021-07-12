import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/indicators.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/enum/message_type.dart';
import 'package:on_delivery/models/new_message_system.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../viewModel/conversation_view_model.dart';
import 'chat_bubble.dart';

class Conversation extends StatefulWidget {
  final String userId;
  final String chatId;
  final bool isAgent;
  final Orders order;

  const Conversation(
      {@required this.userId, @required this.chatId, this.isAgent, this.order});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  bool isFirst = false;
  String chatId;
  int stages = 1;
  Orders initOrder;
  bool agentRole = false;

  @override
  void initState() {
    super.initState();
    getChatOrder();
    getMyRole();
    FirebaseService.changeStatus("Online");
    scrollController.addListener(() {
      focusNode.unfocus();
    });
    if (widget.chatId == 'newChat') {
      isFirst = true;
    }
    chatId = widget.chatId;

    messageController.addListener(() {
      if (focusNode.hasFocus && messageController.text.isNotEmpty) {
        setTyping(true);
      } else if (!focusNode.hasFocus ||
          (focusNode.hasFocus && messageController.text.isEmpty)) {
        setTyping(false);
      }
    });
  }

  setTyping(typing) {
    UserViewModel viewModel = Provider.of<UserViewModel>(context);
    viewModel.setUser();
    var user = Provider.of<UserViewModel>(context, listen: true).user;
    Provider.of<ConversationViewModel>(context, listen: false)
        .setUserTyping(widget.chatId, user, typing);
  }

  getChatOrder() async {
    Orders orders;
    DocumentSnapshot snap = await chatRef.doc(widget.chatId).get();
    if (snap.exists) {
      orders = Orders.fromJson(snap.data()['orders']);
      setState(() {
        initOrder = orders;
      });
    }
  }

  getMyRole() async {
    DocumentSnapshot snap = await chatRef.doc(widget.chatId).get();
    if (snap.exists) {
      List users = snap.data()['users'] ?? [];
      if (users[0].toString().contains(firebaseAuth.currentUser.uid))
        setState(() {
          agentRole = true;
        });
    }
  }

  notificationInto() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 40),
                width: 150,
                child: Center(
                  child: Column(
                    children: [
                      Image.asset("assets/images/informative popups icon.png"),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'You can’t write real time message to the agent until he accepts your offer and you provide the details of delivery that he asks',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          fontFamily: "Poppins",
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedGradientButton(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  border: true,
                  gradient: LinearGradient(
                    colors: <Color>[Colors.white, Colors.white],
                  ),
                  width: SizeConfig.screenWidth - 150,
                  onPressed: () async {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  declineNotificationInto() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 40),
                width: 150,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Are you sure you want to cancel your order ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          fontFamily: "Poppins",
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  RaisedGradientButton(
                      child: Text(
                        'Yes,sure',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                      border: false,
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(82, 238, 79, 1),
                          Color.fromRGBO(5, 151, 0, 1)
                        ],
                      ),
                      width: SizeConfig.screenWidth - 150,
                      onPressed: () async {
                        sendBotMessage(
                            "Thank you for reaching out with me but I’m sorry I am busy.",
                            firebaseAuth.currentUser);
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedGradientButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          letterSpacing: 1,
                        ),
                      ),
                      border: true,
                      gradient: LinearGradient(
                        colors: <Color>[Colors.white, Colors.white],
                      ),
                      width: SizeConfig.screenWidth - 150,
                      onPressed: () async {
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          );
        });
  }

  acceptNotificationInto() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 40),
                width: 150,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Are you sure you want to Confirm your order ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          fontFamily: "Poppins",
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  RaisedGradientButton(
                      child: Text(
                        'Yes,sure',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                      border: false,
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(82, 238, 79, 1),
                          Color.fromRGBO(5, 151, 0, 1)
                        ],
                      ),
                      width: SizeConfig.screenWidth - 150,
                      onPressed: () async {}),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedGradientButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          letterSpacing: 1,
                        ),
                      ),
                      border: true,
                      gradient: LinearGradient(
                        colors: <Color>[Colors.white, Colors.white],
                      ),
                      width: SizeConfig.screenWidth - 150,
                      onPressed: () async {
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel = Provider.of<UserViewModel>(context);
    viewModel.setUser();
    var user = Provider.of<UserViewModel>(context, listen: true).user;
    return Consumer<ConversationViewModel>(
        builder: (BuildContext context, viewModel, Widget child) {
      return SafeArea(
          child: Scaffold(
              key: viewModel.scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Color.fromRGBO(5, 151, 0, 1)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('assets/images/pg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(
                          left: 40, right: 40, top: 20, bottom: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[Colors.white, Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        border:
                            Border.all(color: Color.fromRGBO(216, 224, 240, 1)),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: buildUserName(),
                          ),
                          Flexible(
                            child: StreamBuilder(
                              stream: messageListStream(chatId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List messages = snapshot.data.documents;
                                  if (widget.chatId != 'newChat') {
                                    viewModel.setReadCount(
                                        widget.chatId, user, messages.length);
                                  }
                                  if (messages.length == 0 && stages == 1) {
                                    sendFirstMessageBot();
                                    Timer(Duration(milliseconds: 1), () {
                                      notificationInto();
                                    });
                                  }
                                  return ListView.builder(
                                    controller: scrollController,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 5),
                                    itemCount: messages.length,
                                    reverse: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Message message = Message.fromJson(
                                          messages.reversed
                                              .toList()[index]
                                              .data());
                                      return ChatBubble(
                                        message: '${message.content}',
                                        time: message?.time,
                                        isMe: message?.senderUid == user?.uid,
                                        type: message?.type,
                                        accepted: message.content
                                            .toLowerCase()
                                            .contains(
                                                "Thank you for reaching out with me but I’m sorry I am busy."
                                                    .toLowerCase()),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                      child: circularProgress(context));
                                }
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[Colors.white, Colors.white],
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: Color.fromRGBO(216, 224, 240, 1)),
                                ),
                                child: Container(
                                  constraints: BoxConstraints(maxHeight: 100.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller: messageController,
                                          focusNode: focusNode,
                                          readOnly: stages == 4 ? false : true,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                          ),
                                          onChanged: setTyping(true),
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            enabledBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            hintText: "Type your message ...",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          maxLines: null,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          CupertinoIcons.photo_on_rectangle,
                                          color: stages == 4
                                              ? Color.fromRGBO(20, 20, 43, 1)
                                              : Color.fromRGBO(
                                                  110, 113, 145, 1),
                                        ),
                                        onPressed: () => {
                                          if (stages == 4)
                                            showPhotoOptions(viewModel, user)
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (messageController
                                                  .text.isNotEmpty &&
                                              stages == 4) {
                                            sendMessage(viewModel, user);
                                          }
                                        },
                                        child: Padding(
                                          padding: stages == 4
                                              ? EdgeInsets.only(
                                                  right: 5, top: 8)
                                              : EdgeInsets.only(
                                                  right: 5, top: 0, left: 5),
                                          child: Image.asset(stages == 4
                                              ? "assets/images/send active.png"
                                              : "assets/images/send inactive.png"),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )),
                    widget.isAgent && agentRole && initOrder.lunchStatus == true
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: declineNotificationInto,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: Color.fromRGBO(238, 71, 0, 1)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 50,
                                    width: 150,
                                    margin: EdgeInsets.only(
                                      left: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Decline",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromRGBO(238, 71, 0, 1),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                RaisedGradientButton(
                                    child: Text(
                                      'Confirm Order',
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromRGBO(82, 238, 79, 1),
                                        Color.fromRGBO(5, 151, 0, 1)
                                      ],
                                    ),
                                    width: 150,
                                    onPressed: acceptNotificationInto),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            width: 134,
                            height: 5,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[Colors.grey, Colors.grey],
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[500],
                                    offset: Offset(0.0, 1.5),
                                    blurRadius: 1.5,
                                  ),
                                ]),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              )));
    });
  }

  _buildOnlineText(
    var user,
    bool typing,
  ) {
    if (user.isOnline) {
      if (typing) {
        return "typing...";
      } else {
        return "online";
      }
    } else {
      return 'last seen ${timeago.format(user.lastSeen.toDate())}';
    }
  }

  buildUserName() {
    return StreamBuilder(
      stream: usersRef.doc('${widget.userId}').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data;
          UserModel user = UserModel.fromJson(documentSnapshot.data());
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Stack(
                    fit: StackFit.expand,
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(user.photoUrl != null
                                ? user.photoUrl
                                : "https://image.similarpng.com/very-thumbnail/2020/06/Hand-drawn-delivery-man-with-scooter-royalty-free-PNG.png"),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: new Offset(0.0, 0.0),
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        height: 20,
                        width: 20,
                      ),
                      Positioned(
                        right: -5,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 15,
                          width: 15,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: user?.isOnline ?? false
                                    ? Color(0xff00d72f)
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 10,
                              width: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${user.firstName} ${user.lastname.toUpperCase()}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        '${user.type}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 10.0,
                        ),
                      ),
                      StreamBuilder(
                        stream: chatRef.doc('${widget.chatId}').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            DocumentSnapshot snap = snapshot.data;
                            Map data = snap.data() ?? {};
                            Map usersTyping = data['typing'] ?? {};
                            return Text(
                              _buildOnlineText(
                                user,
                                usersTyping[widget.userId] ?? false,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Color.fromRGBO(216, 224, 240, 1),
                  thickness: 2,
                  height: 2,
                )
              ],
            ),
          );
        } else {
          return Center(child: circularProgress(context));
        }
      },
    );
  }

  showPhotoOptions(ConversationViewModel viewModel, var user) {
    showModalBottomSheet(
      backgroundColor: GBottomNav,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                "Camera",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                sendMessage(viewModel, user, imageType: 0, isImage: true);
              },
            ),
            ListTile(
              title: Text(
                "Gallery",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                sendMessage(viewModel, user, imageType: 1, isImage: true);
              },
            ),
          ],
        );
      },
    );
  }

  sendMessage(ConversationViewModel viewModel, var user,
      {bool isImage = false, int imageType}) async {
    String msg;
    if (isImage) {
      msg = await viewModel.pickImage(
        source: imageType,
        context: context,
        chatId: widget.chatId,
      );
    } else {
      msg = messageController.text.trim();
      messageController.clear();
    }

    Message message = Message(
        content: '$msg',
        senderUid: user?.uid,
        type: isImage ? MessageType.IMAGE : MessageType.TEXT,
        time: Timestamp.now(),
        stages: 4);

    if (msg.isNotEmpty) {
      if (isFirst) {
        String id = await viewModel.sendFirstMessage(
            widget.userId, message, widget.order);
        setState(() {
          isFirst = false;
          chatId = id;
        });
      } else {
        viewModel.sendMessage(
          widget.chatId,
          message,
        );
      }
    }
  }

  sendBotMessage(String msg, var user) async {
    Message message = Message(
        content: '$msg',
        senderUid: user?.uid,
        type: MessageType.TEXT,
        time: Timestamp.now(),
        stages: 4);

    if (msg.isNotEmpty) {
      send(message, widget.chatId);
    }
  }

  send(Message message, String chatId) async {
    await chatRef.doc("$chatId").collection("messages").add(message.toJson());
    await chatRef.doc("$chatId").update({"lastTextTime": Timestamp.now()});
  }

  sendFirstMessageBot() async {
    var user = Provider.of<UserViewModel>(context, listen: true).user;
    var viewModel = Provider.of<ConversationViewModel>(context, listen: true);
    Message message = Message(
        content:
            "automatic message from customer to agent: Hello i want to use your service .....",
        senderUid: user?.uid,
        type: MessageType.TEXT,
        time: Timestamp.now(),
        stages: 2);
    String id =
        await viewModel.sendFirstMessage(widget.userId, message, widget.order);
    setState(() {
      isFirst = false;
      chatId = id;
      stages = 2;
    });
  }

  Stream<QuerySnapshot> messageListStream(String documentId) {
    return chatRef
        .doc(documentId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
}
