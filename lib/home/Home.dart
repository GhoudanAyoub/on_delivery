import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/home/search_screen.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/category.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:provider/provider.dart';

import 'agent_details.dart';

class Home extends StatefulWidget with NavigationStates {
  static String routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel user1;
  int _activeTabHome = 0;
  bool searchClicked = false;
  String CatName;
  List<DocumentSnapshot> agents = [];
  List<DocumentSnapshot> filteredAgents = [];
  bool loading = true;
  bool loadingFavoriteAgents = true;
  bool fav = false;
  TextEditingController _searchedController = TextEditingController();
  ScrollController scrollController = ScrollController();
  UserModel locationService;
  int counter;

  getAgents() async {
    QuerySnapshot snap = await usersRef.get();
    List<DocumentSnapshot> doc = snap.docs;
    agents = doc;
    filteredAgents = doc;
    setState(() {
      loading = false;
    });
  }

  search(String query) {
    if (query == "") {
      filteredAgents = agents;
    } else {
      List userSearch = agents.where((userSnap) {
        Map user = userSnap.data();
        String userName = user['firstName'];
        return userName.toLowerCase().contains(query.toLowerCase()) ||
            user['lastName'].toLowerCase().contains(query.toLowerCase()) ||
            user['activities'].toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredAgents = userSearch;
      });
    }
  }

  getMessageCount() {
    int readCount = 0, messageCount = 0;
    chatRef
        .where("users", arrayContains: firebaseAuth.currentUser.uid)
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((element) {
        readCount +=
            element.doc.data()['reads'][firebaseAuth.currentUser.uid] ?? 0;
        chatRef
            .doc(element.doc.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots()
            .listen((event) {
          messageCount += event.docChanges.length;
        });
      });
    });
    setState(() {
      counter = messageCount - readCount;
    });
  }

  removeFromList(index) {
    filteredAgents.removeAt(index);
  }

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  double getReviews2(id) {
    double i = 0;
    int j = 1;
    rateRef.snapshots().listen((event) {
      event.docChanges.forEach((element) {
        if (element.doc.data()["agentId"].contains(id)) {
          j++;
          i += element.doc.data()["rate"];
        }
      });
    });
    return (i / j);
  }

  @override
  void initState() {
    getAgents();
    getMessageCount();
    super.initState();
  }

  List<Category> categories = [
    Category(
      id: 1,
      name: "My City Agent",
    ),
    Category(
      id: 2,
      name: "Favorite Agents",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    locationService = Provider.of<UserModel>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 10),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                Align(
                  alignment: Alignment.topCenter,
                  child: StreamBuilder(
                    stream:
                        usersRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        user1 = UserModel.fromJson(snapshot.data.data());
                        return Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.transparent,
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
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(239, 240, 246, 1),
                                    radius: 40.0,
                                    backgroundImage: NetworkImage(user1
                                                .photoUrl !=
                                            null
                                        ? user1.photoUrl
                                        : FirebaseService.getProfileImage()),
                                  ),
                                ),
                                height: getProportionateScreenHeight(80),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(10),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          "${user1.firstName} ${user1.lastname.toUpperCase()}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("${user1.city}",
                                          style: TextStyle(
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Text("Company :",
                                          style: TextStyle(
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("${user1.businessName}",
                                          style: TextStyle(
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Text("Tel :",
                                          style: TextStyle(
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("${user1.phone}",
                                          style: TextStyle(
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          ))
                                    ],
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        );
                      }

                      return Container(
                        height: 100,
                        child: Center(
                            child: Lottie.asset(
                                'assets/lotties/loading-animation.json')),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                  stream:
                      usersRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      user1 = UserModel.fromJson(snapshot.data.data());
                      if (user1.type.toLowerCase().contains("client"))
                        return Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color.fromRGBO(82, 238, 79, 1),
                                  Color.fromRGBO(5, 151, 0, 1)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[500],
                                  offset: Offset(0.0, 1.5),
                                  blurRadius: 1.5,
                                ),
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () async {
                                  Navigator.pushNamed(
                                      context, SearchScreen.routeName);
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/looking for agent white.png",
                                        height: 40,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Looking For agent',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        );
                    }
                    return Divider(
                      thickness: 1,
                      color: Color.fromRGBO(230, 230, 230, 1),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: getProportionateScreenHeight(50),
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(top: 15),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _activeTabHome = index;
                                  CatName =
                                      categories[index].name.toLowerCase();
                                  //search(CatName);
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 450),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                height: 10,
                                child: Text(
                                  categories[index].name,
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _activeTabHome == index
                                        ? Colors.black
                                        : Colors.grey[400],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 5.0,
                            );
                          },
                          itemCount: categories.length,
                        ),
                      ),
                      _activeTabHome != 1
                          ? Container(
                              height: getProportionateScreenHeight(50),
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.search,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    searchClicked = !searchClicked;
                                  });
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                searchClicked
                    ? Theme(
                        data: ThemeData(
                          primaryColor: Theme.of(context).accentColor,
                          accentColor: Theme.of(context).accentColor,
                        ),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _searchedController,
                          onChanged: (query) {
                            search(query);
                          },
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                              labelText: "First Name,Last Name, Activities",
                              fillColor: Color.fromRGBO(239, 240, 246, 1),
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(110, 113, 130, 1),
                              ),
                              filled: true,
                              /*hintText: widget.hintText,*/
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
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
                              errorStyle:
                                  TextStyle(height: 0.0, fontSize: 0.0)),
                        ))
                    : SizedBox(
                        height: 0,
                      ),
                homeAgent(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[Colors.grey[300], Colors.grey[300]],
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
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 10),
          child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                BlocProvider.of<NavigationBloc>(context)
                    .add(NavigationEvents.ChatPageClickedEvent);
              },
              child: Icon(
                counter == 0
                    ? CupertinoIcons.chat_bubble_text_fill
                    : CupertinoIcons.chat_bubble_text,
                color: counter == 0 ? Colors.white : Colors.orange,
              )),
        ),
      ),
    );
  }

  homeAgent() {
    return Expanded(
        child: Column(
      children: [
        _activeTabHome == 0
            ? buildAgents()
            : SizedBox(
                height: 0,
              ),
        _activeTabHome == 1
            ? buildFavoriteAgents()
            : SizedBox(
                height: 0,
              ),
      ],
    ));
  }

  buildAgents() {
    if (!loading) {
      if (filteredAgents.isEmpty) {
        return Container(
          height: 150,
          child: Center(child: Lottie.asset('assets/lotties/not_found.json')),
        );
      } else {
        return Flexible(
            child: ListView.builder(
          itemCount: filteredAgents.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 20),
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = filteredAgents[index];
            UserModel _user = UserModel.fromJson(doc.data());
            if ((firebaseAuth.currentUser != null &&
                    doc.id == currentUserId() &&
                    _user.type.toLowerCase().contains("agent")) ||
                _user.type.toLowerCase().contains("client") ||
                _user.isOnline != true ||
                !_user.city.toLowerCase().contains(user1.city)) {
              Timer(Duration(milliseconds: 10), () {
                setState(() {
                  removeFromList(index);
                });
              });
            }
            return Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenHeight(10),
                          right: getProportionateScreenHeight(10)),
                      height: getProportionateScreenHeight(150),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1, color: Color.fromRGBO(231, 231, 231, 1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(_user.photoUrl != null
                                        ? _user.photoUrl
                                        : FirebaseService.getProfileImage()),
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
                                height: getProportionateScreenHeight(60),
                                width: getProportionateScreenHeight(60),
                              ),
                              Container(
                                width: getProportionateScreenWidth(230),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
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
                                        Row(
                                          children: [
                                            Image.asset(
                                                'assets/images/agent rate.png'),
                                            Text(
                                                getReviews2(_user.id) != 0
                                                    ? "${getReviews2(_user.id)}"
                                                    : "NR",
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
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text("${_user.city}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${_user.activities.toLowerCase()}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            )),
                                        Text(
                                            "${_user.price}/${_user.unity.toLowerCase()}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ))
                                      ],
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(231, 231, 231, 1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 30,
                                width: getProportionateScreenWidth(150),
                                margin: EdgeInsets.only(right: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Orders delivered",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        )),
                                    Text("15/19",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(238, 71, 0, 1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 30,
                                width: getProportionateScreenWidth(90),
                                margin: EdgeInsets.only(left: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Details",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          foreground: Paint()
                                            ..shader = orangeLinearGradient,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgentsDetails(
                              id: doc.id,
                            )),
                  );
                },
              ),
            );
          },
        ));
      }
    } else {
      return Container(
        child: Center(child: Lottie.asset('assets/lotties/comp_loading.json')),
      );
    }
  }

  buildFavoriteAgents() {
    return StreamBuilder(
      stream: favoriteListStream(firebaseAuth.currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Flexible(
              child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
                  itemCount: snapshot.data.documents.length,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    UserModel _user = UserModel.fromJson(snapshot
                        .data.documents.reversed
                        .toList()[index]
                        .data());
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(10),
                                  right: getProportionateScreenHeight(10)),
                              height: getProportionateScreenHeight(150),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(231, 231, 231, 1)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.transparent,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                _user.photoUrl != null
                                                    ? _user.photoUrl
                                                    : FirebaseService
                                                        .getProfileImage()),
                                            fit: BoxFit.cover,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              offset: new Offset(0.0, 0.0),
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                        ),
                                        height:
                                            getProportionateScreenHeight(60),
                                        width: getProportionateScreenHeight(60),
                                      ),
                                      Container(
                                        width: getProportionateScreenWidth(220),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("${_user.firstName}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        )),
                                                    _user.verified == "true"
                                                        ? Image.asset(
                                                            "assets/images/ver_agent.png")
                                                        : SizedBox(height: 0)
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/agent rate.png'),
                                                    Text("5.0",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text("${_user.city}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey,
                                                )),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${_user.activities.toLowerCase()}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    )),
                                                Text(
                                                    "${_user.price}/${_user.unity.toLowerCase()}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ))
                                              ],
                                            ),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  231, 231, 231, 1)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 30,
                                        width: getProportionateScreenWidth(150),
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("Orders delivered",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                )),
                                            Text("15/19",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  238, 71, 0, 1)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 30,
                                        width: getProportionateScreenWidth(90),
                                        margin: EdgeInsets.only(
                                            left: 20, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("Details",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  foreground: Paint()
                                                    ..shader =
                                                        orangeLinearGradient,
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AgentsDetails(
                                      id: _user.id,
                                    )),
                          );
                        },
                      ),
                    );
                  }));
        } else {
          return Container(
            height: 150,
            child: Center(child: Lottie.asset('assets/lotties/not_found.json')),
          );
        }
      },
    );
  }

  Stream<QuerySnapshot> favoriteListStream(String documentId) {
    return favoriteRef
        .doc(documentId)
        .collection(favoritesName)
        .orderBy('isOnline')
        .snapshots();
  }
}
