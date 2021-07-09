import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/category.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';
import 'package:on_delivery/utils/firebase.dart';

class OrderScreen extends StatefulWidget with NavigationStates {
  static String routeName = "/orderScreen";
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  UserModel user1;
  int _activeTabHome = 0;
  bool searchClicked = false;
  String CatName;
  TextEditingController _searchedController = TextEditingController();
  List<DocumentSnapshot> orders = [];
  List<DocumentSnapshot> filteredOrders = [];
  bool loading = true;

  getOrders() async {
    QuerySnapshot snap = await orderRef.get();
    List<DocumentSnapshot> doc = snap.docs;
    orders = doc;
    filteredOrders = doc;
    setState(() {
      loading = false;
    });
  }

  search(String query) {
    if (_searchedController.text == "") {
      filteredOrders = orders;
    } else {
      List userSearch = orders.where((userSnap) {
        Map user = userSnap.data();
        String userName = user['firstName'];
        return userName
            .toLowerCase()
            .contains(_searchedController.text.toLowerCase());
      }).toList();

      setState(() {
        filteredOrders = userSearch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                stream: usersRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    user1 = UserModel.fromJson(snapshot.data.data());
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
                    height: 0,
                  );
                },
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Container(
              height: getProportionateScreenHeight(60),
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
                    onTap: () async {},
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/looking for agent white.png",
                            height: getProportionateScreenHeight(40),
                          ),
                          SizedBox(
                            width: getProportionateScreenHeight(20),
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
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            orderAgent(),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                elevation: 4,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(82, 238, 79, 1),
                          Color.fromRGBO(5, 151, 0, 1)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.5,
                        ),
                      ]),
                  child: Center(
                    child: Image.asset(
                      "assets/images/chatbutton.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ),
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
    )));
  }

  orderAgent() {
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
    return Expanded(
        child: ListView(
      children: [
        SizedBox(
          height: 20,
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
                          CatName = categories[index].name.toLowerCase();
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
                              _activeTabHome == index
                                  ? Positioned(
                                      right: -25,
                                      top: -10,
                                      child: Text(
                                        "(${filteredOrders.length.toString()})",
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: _activeTabHome == index
                                              ? Colors.green
                                              : Colors.grey[400],
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
              Container(
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
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
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
                ))
            : SizedBox(
                height: 0,
              ),
        SizedBox(
          height: 10,
        ),
        _activeTabHome == 0
            ? Container(
                child: buildAllOrder(),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10))
            : SizedBox(
                height: 0,
              ),
        _activeTabHome == 1
            ? Container(
                child: buildCurrentOrder(),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10))
            : SizedBox(
                height: 0,
              ),
        _activeTabHome == 2
            ? Container(
                child: buildHistoricOrder(),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10))
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
        return ListView.builder(
          itemCount: filteredOrders.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = filteredOrders[index];
            Orders orders = Orders.fromJson(doc.data());

            return StreamBuilder(
                stream: usersRef.doc(orders.agentId).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data.exists) {
                    UserModel _user = UserModel.fromJson(snapshot.data.data());
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
                                        width: getProportionateScreenWidth(250),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${_user.firstName} ${_user.lastname.toUpperCase()}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    )),
                                                Text(
                                                  "${_user.city}",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text("${_user.city}",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
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
                                                      fontSize: 12,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    )),
                                                Text(
                                                    "${_user.price}/${_user.unity.toLowerCase()}",
                                                    style: TextStyle(
                                                      fontSize: 10,
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
                                                  color: Color.fromRGBO(
                                                      238, 71, 0, 1),
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )),
                        onTap: () {},
                      ),
                    );
                  }
                  return Container(
                    height: 0,
                  );
                });
          },
        );
      }
    } else {
      return Container(
        child: Center(
            child: Lottie.asset('assets/lotties/loading-animation.json')),
      );
    }
  }

  buildCurrentOrder() {
    if (!loading) {
      if (filteredOrders.isEmpty) {
        return Container(
          child: Center(child: Lottie.asset('assets/lotties/not_found.json')),
        );
      } else {
        return ListView.builder(
          itemCount: filteredOrders.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = filteredOrders[index];
            Orders orders = Orders.fromJson(doc.data());

            if (orders.status.toLowerCase().contains("pending")) {
              return StreamBuilder(
                  stream: usersRef.doc(orders.agentId).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.exists) {
                      UserModel _user =
                          UserModel.fromJson(snapshot.data.data());
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
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                offset: new Offset(0.0, 0.0),
                                                blurRadius: 2.0,
                                                spreadRadius: 0.0,
                                              ),
                                            ],
                                          ),
                                          height:
                                              getProportionateScreenHeight(60),
                                          width:
                                              getProportionateScreenHeight(60),
                                        ),
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${_user.firstName} ${_user.lastname.toUpperCase()}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      )),
                                                  Text(
                                                    "${_user.city}",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text("${_user.city}",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
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
                                                        fontSize: 12,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey,
                                                      )),
                                                  Text(
                                                      "${_user.price}/${_user.unity.toLowerCase()}",
                                                      style: TextStyle(
                                                        fontSize: 10,
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
                                          width:
                                              getProportionateScreenWidth(150),
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
                                          width:
                                              getProportionateScreenWidth(90),
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
                                                    color: Color.fromRGBO(
                                                        238, 71, 0, 1),
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          onTap: () {},
                        ),
                      );
                    }
                    return Container(
                      height: 0,
                    );
                  });
            }

            return Container(
              child:
                  Center(child: Lottie.asset('assets/lotties/not_found.json')),
            );
          },
        );
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
        return ListView.builder(
          itemCount: filteredOrders.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = filteredOrders[index];
            Orders orders = Orders.fromJson(doc.data());

            if (orders.status.toLowerCase().contains("canceled") ||
                orders.status.toLowerCase().contains("delivered")) {
              return StreamBuilder(
                  stream: usersRef.doc(orders.agentId).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.exists) {
                      UserModel _user =
                          UserModel.fromJson(snapshot.data.data());
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
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                offset: new Offset(0.0, 0.0),
                                                blurRadius: 2.0,
                                                spreadRadius: 0.0,
                                              ),
                                            ],
                                          ),
                                          height:
                                              getProportionateScreenHeight(60),
                                          width:
                                              getProportionateScreenHeight(60),
                                        ),
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${_user.firstName} ${_user.lastname.toUpperCase()}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      )),
                                                  Text(
                                                    "${_user.city}",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text("${_user.city}",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
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
                                                        fontSize: 12,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey,
                                                      )),
                                                  Text(
                                                      "${_user.price}/${_user.unity.toLowerCase()}",
                                                      style: TextStyle(
                                                        fontSize: 10,
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
                                          width:
                                              getProportionateScreenWidth(150),
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
                                          width:
                                              getProportionateScreenWidth(90),
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
                                                    color: Color.fromRGBO(
                                                        238, 71, 0, 1),
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          onTap: () {},
                        ),
                      );
                    }
                    return Container(
                      height: 0,
                    );
                  });
            }
            return Container(
              child:
                  Center(child: Lottie.asset('assets/lotties/not_found.json')),
            );
          },
        );
      }
    } else {
      return Container(
        child: Center(
            child: Lottie.asset('assets/lotties/loading-animation.json')),
      );
    }
  }
}
