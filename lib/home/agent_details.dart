import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/favorite.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';

class AgentsDetails extends StatefulWidget with NavigationStates {
  static String routeName = "/AgentsDetails";
  final String id;
  final String time;

  const AgentsDetails({Key key, this.id, this.time}) : super(key: key);
  @override
  _AgentsDetailsState createState() => _AgentsDetailsState();
}

class _AgentsDetailsState extends State<AgentsDetails> {
  UserModel _user;
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
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
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
                padding: EdgeInsets.only(left: 20, right: 20),
                children: [
                  StreamBuilder(
                    stream: usersRef.doc(widget.id).snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        _user = UserModel.fromJson(snapshot.data.data());
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
                                      Container(
                                        child: Text("Reviews",
                                            style: TextStyle(
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            )),
                                        width: 60,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 80,
                                            width: 82,
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
                                                  width: 95,
                                                  margin: EdgeInsets.only(
                                                      left: 20, bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                          "${widget.time}min away",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Color.fromRGBO(
                                                                    238,
                                                                    71,
                                                                    0,
                                                                    1),
                                                          )),
                                                    ],
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
                                        Text("15/19",
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
                                            Text("5.0",
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
                                            "${_user.price} ${_user.unity.toLowerCase()}",
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
                                    stream: favoriteRef.snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        FavoriteModel user1 =
                                            FavoriteModel.fromJson(snapshot
                                                .data.docs.
                                                .data());
                                        if (user1.agentData["id"] ==
                                            widget.id) {
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
                                                width: SizeConfig.screenWidth -
                                                    150,
                                                onPressed: () async {}),
                                          );
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
                                              width:
                                                  SizeConfig.screenWidth - 150,
                                              onPressed: () async {
                                                FirebaseService().addToFavorite(
                                                    firebaseAuth.currentUser,
                                                    _user);
                                              }),
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
                                  widget.time != null
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
                                              onPressed: () async {}),
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
                    SizedBox(height: 20),
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
          )),
    ));
  }
}
