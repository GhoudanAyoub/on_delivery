import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/order_layout.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/home/search_screen.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/category.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget with NavigationStates {
  static String routeName = "/orderScreen";
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late UserModel user1;
  int _activeTabHome = 0;
  bool searchClicked = false;
  String? CatName;
  TextEditingController _searchedController = TextEditingController();
  List<DocumentSnapshot> orders = [];
  List<DocumentSnapshot> filteredOrders = [];
  bool loading = true;
  late LocationProvider locationData;
  int myDocs = 0;
  int currentDocs = 0;
  int histoDocs = 0;
  late int counter;

  getOrders() async {
    QuerySnapshot snap = await orderRef.get();
    List<DocumentSnapshot> doc = snap.docs;
    orders = doc;
    filteredOrders = doc;
    setState(() {
      loading = false;
    });
  }

  getMyOrders() {
    orderRef.snapshots().listen((element) {
      element.docChanges.forEach((element) {
        Orders order = Orders.fromJson(element.doc.data());
        if (order.userId != null &&
                order.userId?.contains(firebaseAuth.currentUser.uid) ==true||
            order.agentId != null &&
                order.agentId?.contains(firebaseAuth.currentUser.uid) ==true) {
          setState(() {
            myDocs++;
          });
          if (order.status?.toLowerCase().contains("delivered")==true ||
              order.status?.toLowerCase().contains("canceled")==true)
            setState(() {
              histoDocs++;
            });
          if (order.status?.toLowerCase().contains("pending")==true)
            setState(() {
              currentDocs++;
            });
        }
      });
    });
  }

  getMessageCount() {
    int readCount = 0, messageCount = 0;
    chatRef
        .where("users", arrayContains: firebaseAuth.currentUser.uid)
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((element) {
        readCount += ( 0);
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

  @override
  void initState() {
    getOrders();
    getMyOrders();
    getMessageCount();
    super.initState();
  }

  List<Category> categories = [
    Category(
      id: 1,
      name: "All",
    ),
    Category(
      id: 2,
      name: "Current Orders",
    ),
    Category(
      id: 3,
      name: "Historic",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context);
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
                child: StreamBuilder<DocumentSnapshot>(
                  stream:
                      usersRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      DocumentSnapshot? documentSnapshot = snapshot.data as DocumentSnapshot;
                      Map<String?, dynamic>? mapData = documentSnapshot.data();
                      user1 = UserModel.fromJson(mapData);
                      return Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              height: getProportionateScreenHeight(80),
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
                                  backgroundImage: NetworkImage(
                                      user1.photoUrl != null
                                          ? user1.photoUrl
                                          : FirebaseService.getProfileImage()),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getProportionateScreenHeight(20),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        "${user1.firstName} ${user1.lastname?.toUpperCase()}",
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
                                          fontSize: 12,
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
                                          fontSize: 12,
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
                height: 10,
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: usersRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot? documentSnapshot = snapshot.data as DocumentSnapshot;
                    Map<String?, dynamic>? mapData = documentSnapshot.data();
                    user1 = UserModel.fromJson(mapData);
                    if (user1.type?.toLowerCase().contains("client")==true)
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
                                    context, SearchScreen.routeName);
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(top: 15),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _activeTabHome = index;
                                CatName = categories[index].name?.toLowerCase();
                                //search(CatName);
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 450),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              height: 10,
                              child: Container(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Text(
                                      categories[index].name??"",
                                      style: TextStyle(
                                        letterSpacing: 1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _activeTabHome == index
                                            ? Colors.black
                                            : Colors.grey[400]??Colors.grey,
                                      ),
                                    ),
                                    _activeTabHome == index
                                        ? Positioned(
                                            right: -25,
                                            top: -10,
                                            child: Text(
                                              "(${_activeTabHome == 0 ? myDocs.toString() : _activeTabHome == 1 ? currentDocs.toString() : histoDocs.toString()})",
                                              style: TextStyle(
                                                letterSpacing: 1,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: _activeTabHome == index
                                                    ? Colors.green
                                                    : Colors.grey[400]??Colors.grey,
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 0,
                                            width: 0,
                                          ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
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
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              orderAgent(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Colors.grey[300]??Colors.grey, Colors.grey[300]??Colors.grey],
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
    ));
  }

  orderAgent() {
    return Expanded(
        child: Column(
      children: [
        _activeTabHome == 0
            ? buildAllOrder()
            : SizedBox(
                height: 0,
              ),
        _activeTabHome == 1
            ? buildCurrentOrder()
            : SizedBox(
                height: 0,
              ),
        _activeTabHome == 2
            ? buildHistoricOrder()
            : SizedBox(
                height: 0,
              ),
      ],
    ));
  }

  buildAllOrder() {
    if (!loading) {
      if (filteredOrders.isEmpty) {
        return Container(
          child: Center(child: Lottie.asset('assets/lotties/not_found.json')),
        );
      } else {
        return Flexible(
            child: RefreshIndicator(
          child: ListView.builder(
            itemCount: filteredOrders.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot doc = filteredOrders[index];
              Orders orders = Orders.fromJson(doc.data());

              if (user1.type?.toLowerCase().contains('agent')==true)
                return StreamBuilder<DocumentSnapshot>(
                    stream: usersRef.doc(orders.userId).snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data?.exists==true) {
                        DocumentSnapshot? documentSnapshot = snapshot.data as DocumentSnapshot;
                        Map<String?, dynamic>? mapData = documentSnapshot.data();
                        UserModel _user =
                            UserModel.fromJson(mapData);

                        return OrderLayout(
                          me: user1,
                          order: orders,
                          user: _user,
                          track: false,
                          count: false,
                        );
                      }
                      return Container(
                        height: 0,
                      );
                    });
              return StreamBuilder<DocumentSnapshot>(
                  stream: usersRef.doc(orders.agentId).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data?.exists==true) {
                      DocumentSnapshot? documentSnapshot = snapshot.data as DocumentSnapshot;
                      Map<String?, dynamic>? mapData = documentSnapshot.data();
                      UserModel _user =
                          UserModel.fromJson(mapData);

                      return OrderLayout(
                        me: user1,
                        order: orders,
                        user: _user,
                        track: false,
                        count: false,
                      );
                    }
                    return Container(
                      height: 0,
                    );
                  });
            },
          ),
          onRefresh: _refreshOrders,
        ));
      }
    } else {
      return Container(
        height: 350,
        child: Center(child: Lottie.asset('assets/lotties/comp_loading.json')),
      );
    }
  }

  Future<Null> _refreshOrders() async {
    setState(() {
      myDocs = 0;
      currentDocs = 0;
      histoDocs = 0;
    });
    getOrders();
    getMyOrders();
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
                        'Do You want to delete this Orders?',
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
                        'Yes,',
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
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          );
        });
  }

  buildCurrentOrder() {
    if (!loading) {
      if (filteredOrders.isEmpty) {
        return Container(
          child: Center(child: Lottie.asset('assets/lotties/not_found.json')),
        );
      } else {
        return Flexible(
            child: ListView.builder(
          itemCount: filteredOrders.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = filteredOrders[index];
            Orders orders = Orders.fromJson(doc.data());

            if (orders.status != null &&
                orders.status?.toLowerCase().contains("pending")==true) {
              if (user1.type?.toLowerCase().contains('agent')==true)
                return StreamBuilder<DocumentSnapshot>(
                    stream: usersRef.doc(orders.userId).snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data?.exists==true) {
                        DocumentSnapshot? documentSnapshot = snapshot.data as DocumentSnapshot;
                        Map<String?, dynamic>? mapData = documentSnapshot.data();
                        UserModel _user =
                            UserModel.fromJson(mapData);

                        return OrderLayout(
                          me: user1,
                          order: orders,
                          user: _user,
                          track: user1.type?.toLowerCase().contains("client")==true
                              ? true
                              : false,
                          count: user1.type?.toLowerCase().contains("client")==true
                              ? true
                              : false,
                          show: true,
                        );
                      }
                      return Container(
                        height: 0,
                      );
                    });
              return StreamBuilder<DocumentSnapshot>(
                  stream: usersRef.doc(orders.agentId).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data?.exists==true) {
                      DocumentSnapshot? documentSnapshot = snapshot.data as DocumentSnapshot;
                      Map<String?, dynamic>? mapData = documentSnapshot.data();
                      UserModel _user =
                          UserModel.fromJson(mapData);

                      return OrderLayout(
                        me: user1,
                        order: orders,
                        user: _user,
                        track: user1.type?.toLowerCase().contains("client") == true
                            ? true
                            : false,
                        count: user1.type?.toLowerCase().contains("client") == true
                            ? true
                            : false,
                      );
                    }
                    return Container(
                      height: 0,
                    );
                  });
            }
            return Container();
          },
        ));
      }
    } else {
      return Container(
        child: Center(
            child: Lottie.asset('assets/lotties/loading-animation.json')),
      );
    }
  }

  buildHistoricOrder() {
    if (!loading) {
      if (filteredOrders.isEmpty) {
        return Container(
          child: Center(child: Lottie.asset('assets/lotties/not_found.json')),
        );
      } else {
        return Flexible(
            child: ListView.builder(
          itemCount: filteredOrders.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = filteredOrders[index];
            Orders orders = Orders.fromJson(doc.data());

            if (orders.status != null &&
                    orders.status?.toLowerCase().contains("canceled")==true ||
                orders.status != null &&
                    orders.status?.toLowerCase().contains("delivered")==true) {
              if (user1.type?.toLowerCase().contains('agent')==true)
                return StreamBuilder<DocumentSnapshot>(
                    stream: usersRef.doc(orders.userId).snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data?.exists==true) {
                        DocumentSnapshot? documentSnapshot = snapshot.data as DocumentSnapshot;
                        Map<String?, dynamic>? mapData = documentSnapshot.data();
                        UserModel _user =
                            UserModel.fromJson(mapData);

                        return OrderLayout(
                          me: user1,
                          order: orders,
                          user: _user,
                          track: false,
                          count: false,
                        );
                      }
                      return Container(
                        height: 0,
                      );
                    });
              return StreamBuilder<DocumentSnapshot>(
                  stream: usersRef.doc(orders.agentId).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data?.exists==true) {
                      DocumentSnapshot? documentSnapshot = snapshot.data as DocumentSnapshot;
                      Map<String?, dynamic>? mapData = documentSnapshot.data();
                      UserModel _user =
                          UserModel.fromJson(mapData);

                      return OrderLayout(
                        me: user1,
                        order: orders,
                        user: _user,
                        track: false,
                        count: false,
                      );
                    }
                    return Container(
                      height: 0,
                    );
                  });
            }
            return Container();
          },
        ));
      }
    } else {
      return Container(
        child: Center(
            child: Lottie.asset('assets/lotties/loading-animation.json')),
      );
    }
  }
}
