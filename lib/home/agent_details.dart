import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/Inbox/components/conversation.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/home/reviews.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';
import 'package:on_delivery/utils/firebase.dart';

class AgentsDetails extends StatefulWidget with NavigationStates {
  static String routeName = "/AgentsDetails";
  final String id;
  final String time;
  final Orders order;

  const AgentsDetails({Key key, this.id, this.time, this.order})
      : super(key: key);
  @override
  _AgentsDetailsState createState() => _AgentsDetailsState();
}

class _AgentsDetailsState extends State<AgentsDetails> {
  UserModel _user;
  bool show = true;
  String ChatId;
  double rate;
  int myDocs = 0;
  int doneDocs = 0;
  double i = 0;
  int j = 0;

  getMyOrders(id) {
    orderRef.snapshots().listen((element) {
      for (DocumentSnapshot d in element.docs) {
        Orders order = Orders.fromJson(d.data());
        if (order.agentId.contains(id)) {
          setState(() {
            myDocs++;
          });
          if (order.status.toLowerCase().contains("delivered"))
            setState(() {
              doneDocs++;
            });
        }
      }
    });
  }

  getReviews2(id) {
    rateRef.snapshots().listen((event) {
      event.docChanges.forEach((element) {
        if (element.doc.data()["agentId"].contains(id)) {
          setState(() {
            j++;
            i += element.doc.data()["rate"];
            rate = (i / j);
          });
        }
      });
    });
  }

  @override
  void initState() {
    getChatID();

    getMyOrders(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(5, 151, 0, 1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20)),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Agents",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              ),
              SizedBox(height: 40),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20)),
                children: [
                  StreamBuilder(
                    stream: usersRef.doc(widget.id).snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        _user = UserModel.fromJson(snapshot.data.data());
                        getReviews2(_user.id);
                        return Container(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 10, right: 10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[Colors.white, Colors.white],
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[500],
                                  offset: Offset(0.0, 1.5),
                                  blurRadius: 1.5,
                                ),
                              ]),
                          child: Material(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          child: Text("Reviews",
                                              style: TextStyle(
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.underline,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                foreground: Paint()
                                                  ..shader =
                                                      greenLinearGradient,
                                              )),
                                          width:
                                              getProportionateScreenWidth(60),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Review(
                                                      id: widget.id,
                                                    )),
                                          );
                                        },
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 80,
                                            width:
                                                getProportionateScreenWidth(80),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              overflow: Overflow.visible,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color: Colors.transparent,
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(_user
                                                                  .photoUrl !=
                                                              null
                                                          ? _user.photoUrl
                                                          : "https://image.similarpng.com/very-thumbnail/2020/06/Hand-drawn-delivery-man-with-scooter-royalty-free-PNG.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        offset: new Offset(
                                                            0.0, 0.0),
                                                        blurRadius: 2.0,
                                                        spreadRadius: 0.0,
                                                      ),
                                                    ],
                                                  ),
                                                  height: 70,
                                                  width: 70,
                                                ),
                                                Positioned(
                                                  right: -5,
                                                  bottom: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    height: 20,
                                                    width: 20,
                                                    child: Center(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              _user?.isOnline ??
                                                                      false
                                                                  ? Color(
                                                                      0xff00d72f)
                                                                  : Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                  "${_user.firstName} ${_user.lastname.toUpperCase()}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  )),
                                              _user.verified == "true"
                                                  ? Image.asset(
                                                      "assets/images/ver_agent.png")
                                                  : SizedBox(height: 0)
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text("${_user.city}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          widget.time != null
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Color.fromRGBO(
                                                            238, 71, 0, 1)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 30,
                                                  padding: EdgeInsets.all(8),
                                                  margin: EdgeInsets.only(
                                                      left: 20, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                        "${widget.time} away",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          foreground: Paint()
                                                            ..shader =
                                                                orangeLinearGradient,
                                                        )),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                ),
                                        ],
                                      ),
                                      Container(
                                        width: 40,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Icon(
                                              CupertinoIcons.ellipsis_vertical),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Orders delivered",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )),
                                        Text("$doneDocs/$myDocs",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Rating",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )),
                                        Row(
                                          children: [
                                            Image.asset(
                                                'assets/images/agent rate.png'),
                                            Text(rate != null ? "$rate" : "NR",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Price",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )),
                                        Text(
                                            "${_user.price != "" ? _user.price : "??"} ${_user.unity.toLowerCase()}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: 20,
                                        bottom: 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Means of Transport",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )),
                                        Text("${_user.transportType}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: favoritzListStream(
                                        firebaseAuth.currentUser.uid),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        List favorites =
                                            snapshot.data.documents;
                                        for (DocumentSnapshot document
                                            in favorites) {
                                          UserModel agents = UserModel.fromJson(
                                              document.data());

                                          if (agents.id.contains(widget.id))
                                            return Align(
                                              alignment: Alignment.bottomCenter,
                                              child: RaisedGradientButton(
                                                  child: Text(
                                                    'Delete from favorite',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  border: true,
                                                  gradient: LinearGradient(
                                                    colors: <Color>[
                                                      Colors.white,
                                                      Colors.white
                                                    ],
                                                  ),
                                                  width:
                                                      SizeConfig.screenWidth -
                                                          150,
                                                  onPressed: () async {
                                                    FirebaseService()
                                                        .deleteFromFavorite(
                                                            firebaseAuth
                                                                .currentUser,
                                                            document.id);
                                                  }),
                                            );
                                          return Align(
                                            alignment: Alignment.bottomCenter,
                                            child: RaisedGradientButton(
                                                child: Text(
                                                  'Add to favorite',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                border: true,
                                                gradient: LinearGradient(
                                                  colors: <Color>[
                                                    Colors.white,
                                                    Colors.white
                                                  ],
                                                ),
                                                width: SizeConfig.screenWidth -
                                                    150,
                                                onPressed: () async {
                                                  FirebaseService()
                                                      .addToFavorite(
                                                          firebaseAuth
                                                              .currentUser,
                                                          _user);
                                                }),
                                          );
                                        }
                                      }
                                      return Align(
                                        alignment: Alignment.bottomCenter,
                                        child: RaisedGradientButton(
                                            child: Text(
                                              'Add to favorite',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            border: true,
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                Colors.white,
                                                Colors.white
                                              ],
                                            ),
                                            width: SizeConfig.screenWidth - 150,
                                            onPressed: () async {
                                              FirebaseService().addToFavorite(
                                                  firebaseAuth.currentUser,
                                                  _user);
                                            }),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  widget.time != null && show
                                      ? Align(
                                          alignment: Alignment.bottomCenter,
                                          child: RaisedGradientButton(
                                              child: Text(
                                                'Contact',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color.fromRGBO(
                                                      82, 238, 79, 1),
                                                  Color.fromRGBO(5, 151, 0, 1)
                                                ],
                                              ),
                                              width:
                                                  SizeConfig.screenWidth - 150,
                                              onPressed: () async {
                                                setState(() {
                                                  show = false;
                                                });
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return Conversation(
                                                        userId: _user.id,
                                                        chatId: "newChat",
                                                        isAgent: false,
                                                        order: widget.order,
                                                      );
                                                    },
                                                  ),
                                                );
                                              }),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        )
                                ],
                              )),
                        );
                      }
                      return Container(
                        height: 0,
                      );
                    },
                  ),
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: getProportionateScreenWidth(120),
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
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          )),
    ));
  }

  getChatID() async {
    QuerySnapshot docs = await chatRef.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      if (doc.data()["users"][0].toString().contains(widget.id) == true)
        setState(() {
          ChatId = doc.id;
        });
    }
  }

  Stream<QuerySnapshot> favoritzListStream(String documentId) {
    return favoriteRef
        .doc(documentId)
        .collection(favoritesName)
        .orderBy('isOnline')
        .snapshots();
  }
}
