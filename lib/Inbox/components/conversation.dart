import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoder/geocoder.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/indicators.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/home/trackingmap.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/enum/message_type.dart';
import 'package:on_delivery/models/new_message_system.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/models/rate.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';
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
  TextEditingController reviewController = TextEditingController();
  TextEditingController ribController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  bool isFirst = false;
  String chatId;
  int stages = 1;
  double ratingG = 3;
  Orders initOrder;
  bool agentRole = false;
  bool doneChoosing = false;
  String startFrom, endAt;
  String agentId;
  UserModel agentFullData;
  Message message;

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
    Provider.of<ConversationViewModel>(context, listen: false)
        .setUserTyping(widget.chatId, firebaseAuth.currentUser, typing);
  }

  getChatOrder() async {
    Orders orders;
    DocumentSnapshot snap = await chatRef.doc(widget.chatId).get();
    if (snap.exists) {
      orders = Orders.fromJson(snap.data()['orders']);
      setState(() {
        initOrder = orders;
      });
      getCurrentCoordinatesName();
    }
  }

  getMyRole() async {
    DocumentSnapshot snap = await chatRef.doc(widget.chatId).get();
    if (snap.exists) {
      List users = snap.data()['users'] ?? [];
      if (users[0].toString().contains(firebaseAuth.currentUser.uid))
        setState(() {
          agentRole = true;
          agentId = users[0].toString();
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
                            firebaseAuth.currentUser.uid,
                            3);
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
                      onPressed: () async {
                        sendBotMessage(
                            "Yes,Sure", firebaseAuth.currentUser.uid, 3);
                        sendBotMessage("please confirm you position",
                            firebaseAuth.currentUser.uid, 3);
                        //todo : now update the chat order and the global orders same method but the documents r deference
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

  locationNotificationInto() {
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
                        'Do You want to change your order location?\nif not we will use the one set before',
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
                        'Yes,Change it',
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
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedGradientButton(
                      child: Text(
                        'No keep it',
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
                        sendBotMessage("Deliver the Items to : $endAt",
                            firebaseAuth.currentUser.uid, 3);
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          );
        });
  }

  getReviewForm() {
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
                        'What do you think about my service',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
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
                  RatingBar(
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    glowColor: Colors.white,
                    ratingWidget: RatingWidget(
                      full: Image.asset('assets/images/rating active.png'),
                      empty: Image.asset('assets/images/rating inactive.png'),
                      half: null,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      setState(() {
                        ratingG = rating;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Theme(
                      data: ThemeData(
                        primaryColor: Theme.of(context).accentColor,
                        accentColor: Theme.of(context).accentColor,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        cursorColor: Colors.black,
                        controller: reviewController,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration(
                            labelText: "Review",
                            fillColor: Color.fromRGBO(239, 240, 246, 1),
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(110, 113, 130, 1),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.0,
                              ),
                            ),
                            hoverColor: GBottomNav,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(110, 113, 145, 1),
                                width: 1.0,
                              ),
                            ),
                            errorStyle: TextStyle(height: 0.0, fontSize: 0.0)),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedGradientButton(
                      child: Text(
                        'Publish',
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
                        publishRate();
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          );
        });
  }

  getCurrentCoordinatesName() async {
    final coordinates =
        new Coordinates(initOrder.endAt.latitude, initOrder.endAt.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      endAt = addresses.first.addressLine;
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
                                  if (messages.isNotEmpty &&
                                      messages.reversed.isNotEmpty) {
                                    // ignore: missing_return
                                    Message message2 = Message.fromJson(
                                        messages.reversed.first.data());
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
                                        if (message.content.contains(
                                                "Deliver the Items to") &&
                                            agentRole == true &&
                                            message2.stages == 3) {
                                          sendBotMessage("cash delivery",
                                              firebaseAuth.currentUser.uid, 5);
                                          sendBotMessage("Bank transfer option",
                                              firebaseAuth.currentUser.uid, 5);
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            if (message.content
                                                    .toLowerCase()
                                                    .contains(
                                                        "please confirm you position") &&
                                                agentRole == false &&
                                                message2.stages != 4) {
                                              locationNotificationInto();
                                            }
                                            if (message.content.contains(
                                                    "cash delivery") &&
                                                agentRole == false &&
                                                message2.stages != 4) {
                                              sendBotMessage(
                                                  "You choose Cash on delivery. See you there ",
                                                  agentFullData.id,
                                                  4);
                                            }
                                            if (message.content.contains(
                                                    "Bank transfer option") &&
                                                agentRole == false &&
                                                message2.stages != 4) {
                                              sendBotMessage(
                                                  "You Choose Bank transfer. You can Click On this Msg to get my bank account RIB",
                                                  agentFullData.id,
                                                  4);
                                            }
                                            if (message.content.contains(
                                                    "You Choose Bank transfer. You can Click On this Msg to get my bank account RIB") &&
                                                agentRole == false &&
                                                message2.stages != 6) {
                                              bankAccountID(context);
                                            }
                                          },
                                          child: ChatBubble(
                                            message: '${message.content}',
                                            time: message?.time,
                                            isMe:
                                                message?.senderUid == user?.uid,
                                            type: message?.type,
                                            accepted: message.content
                                                .toLowerCase()
                                                .contains(
                                                    "Thank you for reaching out with me but I’m sorry I am busy."
                                                        .toLowerCase()),
                                          ),
                                        );
                                      },
                                    );
                                  } else
                                    return Container();
                                } else {
                                  return Center(
                                      child: circularProgress(context));
                                }
                              },
                            ),
                          ),
                          StreamBuilder(
                            stream: messageListStream(chatId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List messages = snapshot.data.documents;
                                return Container(
                                  height: 70,
                                  child: ListView.builder(
                                    controller: scrollController,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 5),
                                    itemCount: messages.length,
                                    reverse: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      message = Message.fromJson(messages
                                          .reversed
                                          .toList()[index]
                                          .data());
                                      if (message.stages == 4)
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: <Color>[
                                                    Colors.white,
                                                    Colors.white
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        216, 224, 240, 1)),
                                              ),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: 100.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: TextField(
                                                        controller:
                                                            messageController,
                                                        focusNode: focusNode,
                                                        readOnly: false,
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.black,
                                                        ),
                                                        onChanged:
                                                            setTyping(true),
                                                        cursorColor:
                                                            Colors.black,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10.0),
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Type your message ...",
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        maxLines: null,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        CupertinoIcons
                                                            .photo_on_rectangle,
                                                        color: Color.fromRGBO(
                                                            20, 20, 43, 1),
                                                      ),
                                                      onPressed: () => {
                                                        showPhotoOptions(
                                                            viewModel, user)
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        sendMessage(
                                                            viewModel, user);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5,
                                                                top: 8),
                                                        child: Image.asset(
                                                            "assets/images/send active.png"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        );
                                      else
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: <Color>[
                                                    Colors.white,
                                                    Colors.white
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        216, 224, 240, 1)),
                                              ),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: 100.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: TextField(
                                                        controller:
                                                            messageController,
                                                        focusNode: focusNode,
                                                        readOnly: true,
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.black,
                                                        ),
                                                        onChanged:
                                                            setTyping(true),
                                                        cursorColor:
                                                            Colors.black,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10.0),
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Type your message ...",
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        maxLines: null,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        CupertinoIcons
                                                            .photo_on_rectangle,
                                                        color: Color.fromRGBO(
                                                            110, 113, 145, 1),
                                                      ),
                                                      onPressed: () => {
                                                        if (message.stages == 4)
                                                          showPhotoOptions(
                                                              viewModel, user)
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (messageController
                                                                .text
                                                                .isNotEmpty &&
                                                            message.stages ==
                                                                4) {
                                                          sendMessage(
                                                              viewModel, user);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5,
                                                                top: 0,
                                                                left: 5),
                                                        child: Image.asset(
                                                            "assets/images/send inactive.png"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        );
                                    },
                                  ),
                                );
                              } else {
                                return Center(child: circularProgress(context));
                              }
                            },
                          )
                        ],
                      ),
                    )),
                    StreamBuilder(
                      stream: messageListStream(chatId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List messages = snapshot.data.documents;
                          if (messages != null &&
                              messages.isNotEmpty &&
                              messages.reversed.isNotEmpty)
                            message = Message.fromJson(
                                messages.reversed.first.data());
                          if (message != null) {
                            if (message.stages == 4 &&
                                widget.isAgent == false &&
                                agentRole == false &&
                                initOrder.lunchStatus == true &&
                                initOrder.status
                                    .toLowerCase()
                                    .contains("pending"))
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TrackingMap(
                                                orders: initOrder,
                                                userModel: agentFullData,
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  160, 163, 189, 1)),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                            Text("Track my order",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                      160, 163, 189, 1),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    RaisedGradientButton(
                                        child: Text(
                                          'I\'m delivered',
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
                                        onPressed: imDeliveredButton),
                                  ],
                                ),
                              );
                            else
                              return SizedBox(
                                height: 0,
                              );
                          } else
                            return SizedBox(
                              height: 0,
                            );
                        } else {
                          return Center(child: circularProgress(context));
                        }
                      },
                    ),
                    widget.isAgent &&
                            agentRole &&
                            initOrder.lunchStatus == true &&
                            doneChoosing == false
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

  bankAccountID(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
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
                  child: Text(
                    'There are the bank account information of ${agentFullData.firstName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      fontFamily: "Poppins",
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: usersRef.doc(agentFullData.id).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    UserModel user1 = UserModel.fromJson(snapshot.data.data());
                    ribController.text = user1.RIB;
                    bankNameController.text = user1.bankName;
                    return Column(
                      children: [
                        TextFormBuilder(
                          controller: ribController,
                          hintText: "RIB",
                          suffix: false,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validateFunction: Validations.validateRib,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormBuilder(
                          controller: bankNameController,
                          hintText: "Bank Name",
                          suffix: false,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validateFunction: Validations.validateBankName,
                        ),
                      ],
                    );
                  }
                  return Container(
                    height: 0,
                  );
                },
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
          agentFullData = UserModel.fromJson(documentSnapshot.data());
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
                            image: NetworkImage(agentFullData.photoUrl != null
                                ? agentFullData.photoUrl
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
                                color: agentFullData?.isOnline ?? false
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
                        '${agentFullData.firstName} ${agentFullData.lastname.toUpperCase()}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        '${agentFullData.type}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 10.0,
                        ),
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

  imDeliveredButton() async {
    getReviewForm();

    FirebaseService().updateOrdersStatus(
        "delivered", initOrder.orderId, agentFullData.id, widget.chatId);

    var snapshote = await chatRef
        .doc(chatId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
    snapshote.first.then((value) async {
      await chatRef
          .doc("$chatId")
          .collection("messages")
          .doc(value.docs.last.id)
          .update({"stages": 6});
    });
  }

  publishRate() {
    FirebaseService()
        .addRate(RateModel(
            userID: firebaseAuth.currentUser.uid,
            rate: ratingG,
            rateTxt: reviewController.text,
            timestamp: Timestamp.now(),
            agentId: agentFullData.id))
        .then((value) {
      Navigator.pop(context);
      FirebaseService().deleteChat(firebaseAuth.currentUser, chatId);
    });
  }

  sendBotMessage(String msg, String id, int stage) async {
    Message message = Message(
        content: '$msg',
        senderUid: id,
        type: MessageType.TEXT,
        time: Timestamp.now(),
        stages: stage);

    if (msg.isNotEmpty) {
      if (initOrder != null &&
          initOrder.status != null &&
          !initOrder.status.toLowerCase().contains("delivered")) {
        send(message, widget.chatId);
        if (msg.contains(
            "Thank you for reaching out with me but I’m sorry I am busy.")) {
          FirebaseService().updateOrdersStatus("canceled", initOrder.orderId,
              firebaseAuth.currentUser.uid, widget.chatId);
          setState(() {
            doneChoosing = true;
          });
        }
        if ((msg.contains("Yes,Sure"))) {
          FirebaseService().updateOrdersStatus("pending", initOrder.orderId,
              firebaseAuth.currentUser.uid, widget.chatId);
          setState(() {
            doneChoosing = true;
          });
        }
      }
      if (initOrder != null && initOrder.status == null) {
        send(message, widget.chatId);
        if (msg.contains(
            "Thank you for reaching out with me but I’m sorry I am busy.")) {
          FirebaseService().updateOrdersStatus("canceled", initOrder.orderId,
              firebaseAuth.currentUser.uid, widget.chatId);
          setState(() {
            doneChoosing = true;
          });
        }
        if ((msg.contains("Yes,Sure"))) {
          FirebaseService().updateOrdersStatus("pending", initOrder.orderId,
              firebaseAuth.currentUser.uid, widget.chatId);
          setState(() {
            doneChoosing = true;
          });
        }
      }
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
