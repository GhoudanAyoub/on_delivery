import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/category.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';

class Home extends StatefulWidget with NavigationStates {
  final bool home;
  final bool favoriteAgents;
  final bool search;
  final bool orders;
  static String routeName = "/home";

  const Home(
      {Key key,
      this.home = true,
      this.favoriteAgents = false,
      this.search = false,
      this.orders = false})
      : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel user1;
  int _activeTabHome = 0;
  bool searchClicked = false;
  String CatName;
  TextEditingController _searchedController = TextEditingController();
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
            SizedBox(height: 20),
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
                            width: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                      "${user1.firstName} ${user1.lastname.toUpperCase()}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${user1.city}",
                                      style: TextStyle(
                                        fontSize: 12,
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
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${user1.businessName}",
                                      style: TextStyle(
                                        fontSize: 12,
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
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${user1.phone}",
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
              height: 20,
            ),
            Container(
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
                    onTap: () async {},
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
            ),
            SizedBox(height: 10),
            if (widget.home) homeAgent(),
            if (widget.favoriteAgents) favoriteAgent(),
            if (widget.orders) orderAgent(),
            if (widget.search) searchAgent(),
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

  homeAgent() {
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
                        child: Text(
                          categories[index].name,
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 16,
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
              Container(
                height: 50,
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
            ? TextFormBuilder(
                controller: _searchedController,
                hintText: "Agent name,Activity...",
                suffix: false,
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
              )
            : SizedBox(
                height: 0,
              ),
        SizedBox(
          height: 10,
        ),
        _activeTabHome == 0
            ? StreamBuilder(
                stream: usersRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data.exists) {
                    UserModel _user = UserModel.fromJson(snapshot.data.data());
                    if (_user.type == "Agent" &&
                        _user.city.toLowerCase().contains(user1.city)) {
                      if (_user.firstName.toLowerCase().contains(
                              _searchedController.text.toLowerCase()) ||
                          _user.lastname.toLowerCase().contains(
                              _searchedController.text.toLowerCase()) ||
                          _user.activities
                              .toLowerCase()
                              .contains(_searchedController.text.toLowerCase()))
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(231, 231, 231, 1)),
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
                                            height: 70,
                                            width: 70,
                                          ),
                                          Container(
                                            width: 280,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "${_user.firstName} ${_user.lastname.toUpperCase()}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                    Text(
                                                      "${_user.city}",
                                                      style: TextStyle(
                                                        fontSize: 12,
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
                                                      fontSize: 12,
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
                                                          fontSize: 14,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.grey,
                                                        )),
                                                    Text(
                                                        "${_user.maxWeight}/${_user.unity.toLowerCase()}",
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
                                            width: 197,
                                            margin: EdgeInsets.only(
                                                right: 20, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("Orders delivered",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey,
                                                    )),
                                                Text("15/19",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            width: 95,
                                            margin: EdgeInsets.only(
                                                left: 20, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("Details",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                      else
                        return Container(
                          child: Center(
                              child: Lottie.asset(
                                  'assets/lotties/loading-animation.json')),
                        );
                    }
                    return Container(
                      height: 0,
                    );
                  }
                  return Container(
                    child: Center(
                        child: Lottie.asset(
                            'assets/lotties/loading-animation.json')),
                  );
                },
              )
            : SizedBox(
                height: 0,
              ),
        _activeTabHome == 1
            ? StreamBuilder(
                stream:
                    favoriteRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data.exists) {
                    UserModel _user = UserModel.fromJson(snapshot.data.data());
                    if (_user.firstName
                            .toLowerCase()
                            .contains(_searchedController.text.toLowerCase()) ||
                        _user.lastname
                            .toLowerCase()
                            .contains(_searchedController.text.toLowerCase()) ||
                        _user.activities
                            .toLowerCase()
                            .contains(_searchedController.text.toLowerCase()))
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                height: 150,
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
                                          height: 70,
                                          width: 70,
                                        ),
                                        Container(
                                          width: 280,
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
                                                        fontSize: 14,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      )),
                                                  Text(
                                                    "${_user.city}",
                                                    style: TextStyle(
                                                      fontSize: 12,
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
                                                    fontSize: 12,
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
                                                        fontSize: 14,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey,
                                                      )),
                                                  Text(
                                                      "${_user.maxWeight}/${_user.unity.toLowerCase()}",
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
                                          width: 197,
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
                                          width: 95,
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
                    else
                      return Container(
                        child: Center(
                            child: Lottie.asset(
                                'assets/lotties/loading-animation.json')),
                      );
                  }
                  return Container(
                    child: Center(
                        child:
                            Lottie.asset('assets/lotties/empty-favorite.json')),
                  );
                },
              )
            : SizedBox(
                height: 0,
              ),
      ],
    ));
  }

  favoriteAgent() {
    return Expanded(
        child: ListView(
      children: [],
    ));
  }

  orderAgent() {
    return Expanded(
        child: ListView(
      children: [],
    ));
  }

  searchAgent() {
    return Expanded(
        child: ListView(
      children: [],
    ));
  }
}
