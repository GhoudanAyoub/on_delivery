import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/custom_dropdown.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/helpers/direction_repo.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/helpers/map_model.dart';
import 'package:on_delivery/home/SetUpProfile/UpdateProfile.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/direction_model.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/services/auth_service.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';
import 'package:provider/provider.dart';

import 'agent_details.dart';

const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _activitiesFormKey = GlobalKey<FormState>();
  final _tripFormKey = GlobalKey<FormState>();
  bool food = false,
      move = false,
      ecom = false,
      courier = false,
      icebox = false,
      activityInt = true,
      EcomInt = false,
      foodInt = false,
      moveInt = false,
      corriesInt = false;
  bool locationState = false;
  LocationProvider locationData;
  String startingPointString = "Starting Point",
      arrivalPointString = "Arrive Point",
      brand,
      transport,
      result;

  List brandList = [
    'KFC',
    'MACDONALD',
    'BURGER KING',
    'QUICK',
    'MOL TONE',
  ];
  List transportList = [
    'CAR',
    'MOTO',
    'HONDA',
    'TRUCK',
  ];
  TextEditingController startingPointController = TextEditingController();
  TextEditingController arrivalPointController = TextEditingController();
  TextEditingController maxWeightController = TextEditingController();
  TextEditingController itemNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context, listen: false);

    return Stack(
      children: [
        if (activityInt) activityInterface(),
        if (EcomInt) ecomInterface(),
        if (foodInt) foodInterface(),
        if (moveInt) moveInterface(),
        if (corriesInt) couriesInterface()
      ],
    );
  }

  activityInterface() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              leading: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromRGBO(5, 151, 0, 1)),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              title: Padding(
                padding: EdgeInsets.only(right: 30, top: 40),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("Advanced Search",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _activitiesFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/pg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(30),
                        50,
                        getProportionateScreenWidth(30),
                        10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              "What activity/activities are you looking for?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: ListView(
                          padding: EdgeInsets.all(10),
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        food = true;
                                        move = false;
                                        ecom = false;
                                        courier = false;
                                      });
                                    },
                                    child: Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 120,
                                          width:
                                              getProportionateScreenWidth(120),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: food
                                                    ? [
                                                        Color.fromRGBO(
                                                            255, 182, 40, 1),
                                                        Color.fromRGBO(
                                                            238, 71, 0, 1),
                                                      ]
                                                    : [
                                                        Color.fromRGBO(
                                                            239, 240, 246, 1),
                                                        Color.fromRGBO(
                                                            239, 240, 246, 1)
                                                      ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[500],
                                                  offset: Offset(0.0, 1.5),
                                                  blurRadius: 1.5,
                                                ),
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'FOOD',
                                                style: TextStyle(
                                                    color: food
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 1,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ))),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        courier = false;
                                        food = false;
                                        move = true;
                                        ecom = false;
                                      });
                                    },
                                    child: Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 120,
                                          width:
                                              getProportionateScreenWidth(120),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: move
                                                    ? [
                                                        Color.fromRGBO(
                                                            255, 182, 40, 1),
                                                        Color.fromRGBO(
                                                            238, 71, 0, 1),
                                                      ]
                                                    : [
                                                        Color.fromRGBO(
                                                            239, 240, 246, 1),
                                                        Color.fromRGBO(
                                                            239, 240, 246, 1)
                                                      ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[500],
                                                  offset: Offset(0.0, 1.5),
                                                  blurRadius: 1.5,
                                                ),
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'MOVE',
                                                style: TextStyle(
                                                    color: move
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 1,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ))),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        courier = false;
                                        food = false;
                                        move = false;
                                        ecom = true;
                                      });
                                    },
                                    child: Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 120,
                                          width:
                                              getProportionateScreenWidth(120),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: ecom
                                                    ? [
                                                        Color.fromRGBO(
                                                            255, 182, 40, 1),
                                                        Color.fromRGBO(
                                                            238, 71, 0, 1),
                                                      ]
                                                    : [
                                                        Color.fromRGBO(
                                                            239, 240, 246, 1),
                                                        Color.fromRGBO(
                                                            239, 240, 246, 1)
                                                      ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[500],
                                                  offset: Offset(0.0, 1.5),
                                                  blurRadius: 1.5,
                                                ),
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'E-commerce',
                                                style: TextStyle(
                                                    color: ecom
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 1,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ))),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        courier = true;
                                        food = false;
                                        move = false;
                                        ecom = false;
                                      });
                                    },
                                    child: Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 120,
                                          width:
                                              getProportionateScreenWidth(120),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: courier
                                                    ? [
                                                        Color.fromRGBO(
                                                            255, 182, 40, 1),
                                                        Color.fromRGBO(
                                                            238, 71, 0, 1),
                                                      ]
                                                    : [
                                                        Color.fromRGBO(
                                                            239, 240, 246, 1),
                                                        Color.fromRGBO(
                                                            239, 240, 246, 1)
                                                      ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[500],
                                                  offset: Offset(0.0, 1.5),
                                                  blurRadius: 1.5,
                                                ),
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'COURIER',
                                                style: TextStyle(
                                                    color: courier
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 1,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ))),
                              ],
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        food || move || ecom || courier
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  children: [
                                    RaisedGradientButton(
                                        child: Text(
                                          'Next',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
                                          ],
                                        ),
                                        width: SizeConfig.screenWidth - 150,
                                        onPressed: () async {
                                          setState(() {
                                            ecom
                                                ? EcomInt = true
                                                : EcomInt = false;
                                            food
                                                ? foodInt = true
                                                : foodInt = false;
                                            move
                                                ? moveInt = true
                                                : moveInt = false;
                                            courier
                                                ? corriesInt = true
                                                : corriesInt = false;
                                            activityInt = false;
                                          });
                                        }),
                                    SizedBox(height: 20),
                                    Container(
                                      width: 134,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Colors.grey,
                                              Colors.grey
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[500],
                                              offset: Offset(0.0, 1.5),
                                              blurRadius: 1.5,
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(height: 0),
                      ],
                    ),
                  ),
                ))));
  }

  ecomInterface() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              leading: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromRGBO(5, 151, 0, 1)),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              title: Padding(
                padding: EdgeInsets.only(right: 30, top: 40),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("E-commerce Search",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _tripFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/pg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(30),
                        50,
                        getProportionateScreenWidth(30),
                        10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              "Choose the location and weight of your Item.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Choose my position as a\n starting point",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
                                      )),
                                ),
                                Container(
                                  height: 30,
                                  width: 70,
                                  child: CustomSwitch(
                                    value: locationState,
                                    activeColor: Colors.green,
                                    onChanged: (state) {
                                      if (state == true)
                                        locationData.getCurrentPosition();

                                      locationData
                                          .getMoveCamera()
                                          .then((value) => setState(() {
                                                locationState = state;
                                                startingPointString = value;
                                              }));
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await locationData.getCurrentPosition();
                                  if (locationData.permissionGranted) {
                                    result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchMapTripScreen(),
                                        ));
                                    setState(() {
                                      arrivalPointString = result.split("/")[1];
                                    });
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              onSurface: Colors.white,
                                              primary: Colors.transparent,
                                              onPrimary: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                              ),
                                              minimumSize:
                                                  Size(100, 40), //////// HERE
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          180),
                                                  child: Text(
                                                    startingPointString,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/starting point.png')
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.grey[400],
                                        ),
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 4,
                                              onSurface: Colors.white,
                                              primary: Colors.transparent,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              minimumSize:
                                                  Size(100, 40), //////// HERE
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          150),
                                                  child: Text(
                                                    arrivalPointString,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/arrival point.png')
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              child: TextFormBuilder(
                                controller: maxWeightController,
                                hintText: "Max Weight",
                                suffix: false,
                                prefix: CupertinoIcons.arrow_up_down,
                                textInputAction: TextInputAction.next,
                                validateFunction: Validations.validateNumber,
                              ),
                              height: 100,
                              width: 150,
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              RaisedGradientButton(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/looking for agent white.png",
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Search',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color.fromRGBO(82, 238, 79, 1),
                                      Color.fromRGBO(5, 151, 0, 1)
                                    ],
                                  ),
                                  width: SizeConfig.screenWidth - 150,
                                  onPressed: () async {
                                    if (startingPointString != null &&
                                        arrivalPointString != null) {
                                      Orders order = new Orders(
                                        userId: firebaseAuth.currentUser.uid,
                                        lunchStatus: true,
                                        maxWeight: maxWeightController.text,
                                        brand: brand,
                                        iceBox: icebox,
                                        numberItem: itemNumberController.text,
                                        transport: transport,
                                        startAt: GeoPoint(
                                            locationData.lnt, locationData.lng),
                                      );
                                      FirebaseService().updateOrders(
                                          firebaseAuth.currentUser,
                                          order,
                                          result.split('/')[0]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchMapAgentScreen(
                                              orders: result.split('/')[0],
                                            ),
                                          ));
                                    }
                                  }),
                              SizedBox(height: 10),
                              Container(
                                width: 135,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }

  couriesInterface() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              leading: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromRGBO(5, 151, 0, 1)),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              title: Padding(
                padding: EdgeInsets.only(right: 30, top: 40),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("Courier Search",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _tripFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/pg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(30),
                        50,
                        getProportionateScreenWidth(30),
                        10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              "Choose the location and the destination of the item",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Choose my position as a\n starting point",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
                                      )),
                                ),
                                Container(
                                  height: 30,
                                  width: 70,
                                  child: CustomSwitch(
                                    value: locationState,
                                    activeColor: Colors.green,
                                    onChanged: (state) {
                                      if (state == true)
                                        locationData.getCurrentPosition();

                                      locationData
                                          .getMoveCamera()
                                          .then((value) => setState(() {
                                                locationState = state;
                                                startingPointString = value;
                                              }));
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await locationData.getCurrentPosition();
                                  if (locationData.permissionGranted) {
                                    result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchMapTripScreen(),
                                        ));
                                    setState(() {
                                      arrivalPointString = result.split("/")[1];
                                    });
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              onSurface: Colors.white,
                                              primary: Colors.transparent,
                                              onPrimary: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                              ),
                                              minimumSize:
                                                  Size(100, 40), //////// HERE
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          180),
                                                  child: Text(
                                                    startingPointString,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/starting point.png')
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.grey[400],
                                        ),
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 4,
                                              onSurface: Colors.white,
                                              primary: Colors.transparent,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              minimumSize:
                                                  Size(100, 40), //////// HERE
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          150),
                                                  child: Text(
                                                    arrivalPointString,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/arrival point.png')
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              RaisedGradientButton(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/looking for agent white.png",
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Search',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color.fromRGBO(82, 238, 79, 1),
                                      Color.fromRGBO(5, 151, 0, 1)
                                    ],
                                  ),
                                  width: SizeConfig.screenWidth - 150,
                                  onPressed: () async {
                                    if (startingPointString != null &&
                                        arrivalPointString != null) {
                                      Orders order = new Orders(
                                        userId: firebaseAuth.currentUser.uid,
                                        lunchStatus: true,
                                        maxWeight: maxWeightController.text,
                                        brand: brand,
                                        iceBox: icebox,
                                        numberItem: itemNumberController.text,
                                        transport: transport,
                                        startAt: GeoPoint(
                                            locationData.lnt, locationData.lng),
                                      );
                                      FirebaseService().updateOrders(
                                          firebaseAuth.currentUser,
                                          order,
                                          result.split('/')[0]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchMapAgentScreen(
                                              orders: result.split('/')[0],
                                            ),
                                          ));
                                    }
                                  }),
                              SizedBox(height: 10),
                              Container(
                                width: 135,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }

  foodInterface() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              leading: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromRGBO(5, 151, 0, 1)),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              title: Padding(
                padding: EdgeInsets.only(right: 30, top: 40),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("Food Search",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _tripFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/pg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(30),
                        50,
                        getProportionateScreenWidth(30),
                        10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              "Choose the location and the brand that you prefere to eat.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Choose my position as a\n starting point",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
                                      )),
                                ),
                                Container(
                                  height: 30,
                                  width: 70,
                                  child: CustomSwitch(
                                    value: locationState,
                                    activeColor: Colors.green,
                                    onChanged: (state) {
                                      if (state == true)
                                        locationData.getCurrentPosition();

                                      locationData
                                          .getMoveCamera()
                                          .then((value) => setState(() {
                                                locationState = state;
                                                startingPointString = value;
                                              }));
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("With IceBox",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
                                      )),
                                ),
                                Container(
                                  height: 30,
                                  width: 70,
                                  child: CustomSwitch(
                                    value: locationState,
                                    activeColor: Colors.green,
                                    onChanged: (state) {
                                      setState(() {
                                        icebox = state;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await locationData.getCurrentPosition();
                                  if (locationData.permissionGranted) {
                                    result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchMapTripScreen(),
                                        ));
                                    setState(() {
                                      arrivalPointString = result.split("/")[1];
                                    });
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              onSurface: Colors.white,
                                              primary: Colors.transparent,
                                              onPrimary: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                              ),
                                              minimumSize:
                                                  Size(100, 40), //////// HERE
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          180),
                                                  child: Text(
                                                    startingPointString,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/starting point.png')
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.grey[400],
                                        ),
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 4,
                                              onSurface: Colors.white,
                                              primary: Colors.transparent,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              minimumSize:
                                                  Size(100, 40), //////// HERE
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          150),
                                                  child: Text(
                                                    arrivalPointString,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/arrival point.png')
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            SizedBox(
                              height: 40,
                            ),
                            CustomDropdown<int>(
                              child: Text(
                                'Brand',
                              ),
                              onChange: (int value, int index) => {
                                setState(() {
                                  brand = brandList[index];
                                }),
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                width: 150,
                                height: 45,
                                backgroundColor:
                                    Color.fromRGBO(239, 240, 246, 1),
                                primaryColor: Colors.black87,
                              ),
                              dropdownStyle: DropdownStyle(
                                color: Color.fromRGBO(239, 240, 246, 1),
                                borderRadius: BorderRadius.circular(8),
                                elevation: 6,
                                padding: EdgeInsets.all(5),
                              ),
                              items: brandList
                                  .asMap()
                                  .entries
                                  .map(
                                    (item) => DropdownItem<int>(
                                      value: item.key + 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          item.value,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              RaisedGradientButton(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/looking for agent white.png",
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Search',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color.fromRGBO(82, 238, 79, 1),
                                      Color.fromRGBO(5, 151, 0, 1)
                                    ],
                                  ),
                                  width: SizeConfig.screenWidth - 150,
                                  onPressed: () async {
                                    if (startingPointString != null &&
                                        arrivalPointString != null) {
                                      Orders order = new Orders(
                                        userId: firebaseAuth.currentUser.uid,
                                        lunchStatus: true,
                                        maxWeight: maxWeightController.text,
                                        brand: brand,
                                        iceBox: icebox,
                                        numberItem: itemNumberController.text,
                                        transport: transport,
                                        startAt: GeoPoint(
                                            locationData.lnt, locationData.lng),
                                      );
                                      FirebaseService().updateOrders(
                                          firebaseAuth.currentUser,
                                          order,
                                          result.split('/')[0]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchMapAgentScreen(
                                              orders: result.split('/')[0],
                                            ),
                                          ));
                                    }
                                  }),
                              SizedBox(height: 10),
                              Container(
                                width: 135,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }

  moveInterface() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              leading: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromRGBO(5, 151, 0, 1)),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              title: Padding(
                padding: EdgeInsets.only(right: 30, top: 40),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("Move Search",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _tripFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/pg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(30),
                        50,
                        getProportionateScreenWidth(30),
                        10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              "Choose the location and weight of your Item.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Choose my position as a\n starting point",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
                                      )),
                                ),
                                Container(
                                  height: 30,
                                  width: 70,
                                  child: CustomSwitch(
                                    value: locationState,
                                    activeColor: Colors.green,
                                    onChanged: (state) {
                                      if (state == true)
                                        locationData.getCurrentPosition();

                                      locationData
                                          .getMoveCamera()
                                          .then((value) => setState(() {
                                                locationState = state;
                                                startingPointString = value;
                                              }));
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await locationData.getCurrentPosition();
                                  if (locationData.permissionGranted) {
                                    result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchMapTripScreen(),
                                        ));
                                    print("12221${result.split("/")[0]}");
                                    setState(() {
                                      arrivalPointString = result.split("/")[1];
                                    });
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              onSurface: Colors.white,
                                              primary: Colors.transparent,
                                              onPrimary: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                              ),
                                              minimumSize:
                                                  Size(100, 40), //////// HERE
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          180),
                                                  child: Text(
                                                    startingPointString,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/starting point.png')
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.grey[400],
                                        ),
                                        Container(
                                          width:
                                              getProportionateScreenWidth(250),
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 4,
                                              onSurface: Colors.white,
                                              primary: Colors.transparent,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              minimumSize:
                                                  Size(100, 40), //////// HERE
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          150),
                                                  child: Text(
                                                    arrivalPointString,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/arrival point.png')
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            SizedBox(
                              height: 40,
                            ),
                            CustomDropdown<int>(
                              child: Text(
                                'Transport',
                              ),
                              onChange: (int value, int index) => {
                                setState(() {
                                  transport = transportList[index];
                                }),
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                width: 150,
                                height: 45,
                                backgroundColor:
                                    Color.fromRGBO(239, 240, 246, 1),
                                primaryColor: Colors.black87,
                              ),
                              dropdownStyle: DropdownStyle(
                                color: Color.fromRGBO(239, 240, 246, 1),
                                borderRadius: BorderRadius.circular(8),
                                elevation: 6,
                                padding: EdgeInsets.all(5),
                              ),
                              items: transportList
                                  .asMap()
                                  .entries
                                  .map(
                                    (item) => DropdownItem<int>(
                                      value: item.key + 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          item.value,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: TextFormBuilder(
                                controller: maxWeightController,
                                hintText: "Max Weight",
                                suffix: false,
                                prefix: CupertinoIcons.arrow_up_down,
                                textInputAction: TextInputAction.next,
                                validateFunction: Validations.validateNumber,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: TextFormBuilder(
                                controller: itemNumberController,
                                hintText: "Number of Items",
                                suffix: false,
                                prefix: CupertinoIcons.arrow_up_down,
                                textInputAction: TextInputAction.next,
                                validateFunction: Validations.validateNumber,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              RaisedGradientButton(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/looking for agent white.png",
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Search',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color.fromRGBO(82, 238, 79, 1),
                                      Color.fromRGBO(5, 151, 0, 1)
                                    ],
                                  ),
                                  width: SizeConfig.screenWidth - 150,
                                  onPressed: () async {
                                    if (startingPointString != null &&
                                        arrivalPointString != null) {
                                      Orders order = new Orders(
                                        userId: firebaseAuth.currentUser.uid,
                                        lunchStatus: true,
                                        maxWeight: maxWeightController.text,
                                        brand: brand,
                                        iceBox: icebox,
                                        numberItem: itemNumberController.text,
                                        transport: transport,
                                        startAt: GeoPoint(
                                            locationData.lnt, locationData.lng),
                                      );
                                      FirebaseService().updateOrders(
                                          firebaseAuth.currentUser,
                                          order,
                                          result.split('/')[0]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchMapAgentScreen(
                                              orders: result.split('/')[0],
                                            ),
                                          ));
                                    }
                                  }),
                              SizedBox(height: 10),
                              Container(
                                width: 135,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}

class SearchMapTripScreen extends StatefulWidget {
  static String routeName = '/SearchMapTripScreen';
  final User user;

  const SearchMapTripScreen({Key key, this.user}) : super(key: key);
  @override
  _SearchMapTripScreenState createState() => _SearchMapTripScreenState();
}

class _SearchMapTripScreenState extends State<SearchMapTripScreen> {
  LocationProvider locationData;
  LatLng currentLocation;
  GoogleMapController _mapController;
  AuthService authService = AuthService();
  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _myPosition;
  static CameraPosition initPosition;
  String startingTripLocationString = "Starting Point";
  String arriveTripLocationString = "Arrival Point";
  PlacesDetailsResponse detail;
  Prediction p, p2;
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  double startingLocationLnt, startingLocationLng;
  double arrivedLocationLnt, arrivedLocationLng;
  bool start = true;
  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context);
    setState(() {
      currentLocation = LatLng(locationData.lnt, locationData.lng);
    });
    void onCreate(GoogleMapController controller) {
      _controller.complete(controller);
      _mapController = controller;
      setState(() {
        initPosition =
            CameraPosition(target: LatLng(locationData.lnt, locationData.lng));
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(
              context, p2 != null ? p2.description : arriveTripLocationString);
        },
        child: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: currentLocation),
                zoomControlsEnabled: false,
                minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                onCameraMove: (CameraPosition positon) {
                  locationData.onCameraMove(positon);
                },
                onMapCreated: onCreate,
                onCameraIdle: () {
                  locationData.getMoveCamera().then((value) => setState(() {
                        start
                            ? startingTripLocationString = value
                            : arriveTripLocationString = value;
                      }));
                  locationData.getMoveCameraLntLng().then((value) => start
                      ? startingLocationLnt = value.latitude
                      : startingLocationLng = value.longitude);
                  locationData.getMoveCameraLntLng().then((value) => start
                      ? arrivedLocationLnt = value.latitude
                      : arrivedLocationLng = value.longitude);
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 50, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                  context,
                                  p2 != null
                                      ? p2.description
                                      : arriveTripLocationString);
                            },
                            child: Image.asset(
                              "assets/images/Back Arrow.png",
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () =>
                                _goToMyPosition(_controller.future),
                            mini: true,
                            elevation: 8,
                            backgroundColor: Colors.white,
                            child:
                                Image.asset("assets/images/geolocate me.png"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handlePressButton,
                        style: ElevatedButton.styleFrom(
                          onSurface: Colors.white,
                          primary: Colors.white,
                          onPrimary: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          minimumSize: Size(100, 40), //////// HERE
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 220,
                              child: Text(
                                startingTripLocationString,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Image.asset('assets/images/starting point.png')
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey[400],
                      width: 250,
                    ),
                    Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handlePressButton2,
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          onSurface: Colors.white,
                          primary: Colors.white,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          minimumSize: Size(100, 40), //////// HERE
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 220,
                              child: Text(
                                arriveTripLocationString,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Image.asset('assets/images/arrival point.png')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 100,
                      margin: EdgeInsets.only(bottom: 40),
                      child: Image.asset(
                          'assets/images/fixed location in map.png'))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: RaisedGradientButton(
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(82, 238, 79, 1),
                          Color.fromRGBO(5, 151, 0, 1)
                        ],
                      ),
                      width: SizeConfig.screenWidth - 150,
                      onPressed: () async {
                        Orders order = new Orders(
                            userId: firebaseAuth.currentUser.uid,
                            lunchStatus: false,
                            startAt: GeoPoint(
                                locationData.lnt != null
                                    ? locationData.lnt
                                    : startingLocationLnt,
                                locationData.lng != null
                                    ? locationData.lng
                                    : startingLocationLng),
                            endAt: GeoPoint(
                                arrivedLocationLnt, arrivedLocationLng));

                        var id = await FirebaseService()
                            .addOrder(firebaseAuth.currentUser, order);
                        Navigator.pop(context,
                            "$id/${p2 != null ? p2.description : arriveTripLocationString}");
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToMyPosition(c) async {
    _myPosition = CameraPosition(
      target:
          LatLng(initPosition.target.latitude, initPosition.target.longitude),
      zoom: 14.5,
    );
    await locationData.getCurrentPosition();
    final GoogleMapController controller = await c;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myPosition));
  }

  Future<void> _goToPosition(c, latitude, longitude) async {
    _myPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 18.5,
    );
    await locationData.getCurrentPosition();
    final GoogleMapController controller = await c;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myPosition));
  }

  void onError(PlacesAutocompleteResponse response) {
    debugPrint('${response.errorMessage}');
  }

  Future<void> _handlePressButton() async {
    setState(() {
      start = true;
    });
    p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      hint: 'Starting Point',
      onError: onError,
      language: "fr",
      overlayBorderRadius: BorderRadius.all(Radius.circular(10)),
      components: [Component(Component.country, "mar")],
    );

    displayStartingPrediction(p, homeScaffoldKey.currentState);
  }

  Future<void> _handlePressButton2() async {
    setState(() {
      start = false;
    });
    p2 = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      hint: 'Arrive Point',
      onError: onError,
      language: "fr",
      overlayBorderRadius: BorderRadius.all(Radius.circular(10)),
      components: [Component(Component.country, "mar")],
    );

    displayArrivedPrediction(p2, homeScaffoldKey.currentState);
  }

  Future<Null> displayStartingPrediction(
      Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      setState(() {
        startingLocationLnt = detail.result.geometry.location.lat;
        startingLocationLng = detail.result.geometry.location.lng;
        startingTripLocationString = p.description;
      });
      _goToPosition(
          _controller.future, startingLocationLnt, startingLocationLng);
    }
  }

  Future<Null> displayArrivedPrediction(
      Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      setState(() {
        arrivedLocationLnt = detail.result.geometry.location.lat;
        arrivedLocationLng = detail.result.geometry.location.lng;
        arriveTripLocationString = p2.description;
      });
      _goToPosition(_controller.future, arrivedLocationLnt, arrivedLocationLng);
    }
  }
}

class SearchMapAgentScreen extends StatefulWidget {
  static String routeName = '/SearchMapAgentScreen';
  final User user;
  final String orders;

  const SearchMapAgentScreen({Key key, this.user, this.orders})
      : super(key: key);
  @override
  _SearchMapAgentScreenState createState() => _SearchMapAgentScreenState();
}

class _SearchMapAgentScreenState extends State<SearchMapAgentScreen> {
  LocationProvider locationData;
  LatLng currentLocation;
  GoogleMapController _mapController;
  AuthService authService = AuthService();
  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _myPosition;
  static CameraPosition initPosition;
  String startingTripLocationString = "Starting Point";
  String arriveTripLocationString = "Arrival Point";
  PlacesDetailsResponse detail;
  Prediction p, p2;
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  double startingLocationLnt, startingLocationLng;
  double arrivedLocationLnt, arrivedLocationLng;
  bool start = true;
  UserModel locationService;
  BitmapDescriptor myIcon;
  MyModel myModel;
  Set<Marker> customMarkers = Set<Marker>();
  UserModel agent1;
  List<UserModel> userList = [];
  List<DocumentSnapshot> filteredAgents = [];
  List<DocumentSnapshot> filteredAgentsLocation = [];
  String agentLocationId;
  Directions _info;
  Marker _origin;
  Marker _destination;
  List agentTime = [];
  double pinPillPosition = PIN_VISIBLE_POSITION;
  double soloPinPillPosition = PIN_INVISIBLE_POSITION;

  getAgents() async {
    QuerySnapshot snap = await usersRef.get();
    List<DocumentSnapshot> doc = snap.docs;
    filteredAgents = doc;
    for (DocumentSnapshot d in filteredAgents) {
      UserModel user1 = UserModel.fromJson(d.data());
      if ((user1.type.toLowerCase().contains("agent") &&
              user1.isOnline == true ||
          user1.id.contains(firebaseAuth.currentUser.uid))) {
        customMarkers.add(_createMarker(user1.Lnt, user1.Lng, d.id));
        getInfoTime(LatLng(user1.Lnt, user1.Lng)).then((value) {
          setState(() {
            agentTime.add(value);
          });
        });
        if (!user1.id.contains(firebaseAuth.currentUser.uid))
          userList.add(user1);

        if (d.id.contains(firebaseAuth.currentUser.uid))
          setState(() {
            _origin = Marker(
              markerId: MarkerId('origin'),
              infoWindow: const InfoWindow(title: 'Origin'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              position: LatLng(user1.Lnt, user1.Lng),
            );
            _info = null;
          });
      }
    }
    if (userList.length == 0)
      Fluttertoast.showToast(
          msg: "No Agents Online",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
  }

  Future getInfoTime(_destination) async {
    Directions directions;
    if (_origin != null) {
      directions = await DirectionsRepository()
          .getDirections(origin: _origin.position, destination: _destination);
      setState(() => _info = directions);
    }
    return directions.totalDuration;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    myIcon = BitmapDescriptor.fromAsset("assets/images/mylocationmarker.png");
    super.initState();
  }

  notificationInto(BuildContext parentContext) {
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
                    'Click on the agents on the map to chose the one you want or slid them in the bottom',
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

  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context);
    locationService = Provider.of<UserModel>(context);
    myModel = Provider.of<MyModel>(context);
    setState(() {
      currentLocation = LatLng(locationService.Lnt, locationService.Lng);
    });
    void onCreate(GoogleMapController controller) {
      _controller.complete(controller);
      _mapController = controller;
      getAgents();
      setState(() {
        initPosition = CameraPosition(
            target: LatLng(locationService.Lnt, locationService.Lng));
      });
      customMarkers.add(_createMarker(locationService.Lnt, locationService.Lng,
          firebaseAuth.currentUser.uid));
      notificationInto(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: FutureBuilder<QuerySnapshot>(
        future: usersRef.get(),
        builder: (context, snapshot) {
          if (snapshot.data != null && _origin != null) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: currentLocation, zoom: 14),
                    zoomControlsEnabled: false,
                    minMaxZoomPreference: MinMaxZoomPreference(6.5, 20.8),
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    markers: customMarkers,
                    mapToolbarEnabled: true,
                    onCameraMove: (CameraPosition positon) {
                      locationData.onCameraMove(positon);
                    },
                    onTap: (LatLng loc) {
                      setState(() {
                        this.pinPillPosition = PIN_VISIBLE_POSITION;
                        this.soloPinPillPosition = PIN_INVISIBLE_POSITION;
                      });
                    },
                    onMapCreated: onCreate,
                  ),
                ),
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    left: 0,
                    right: 0,
                    bottom: this.pinPillPosition,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: 200,
                      child: ListView.builder(
                        itemCount: userList.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 50),
                        itemBuilder: (BuildContext context, int index) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
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
                                                  image: NetworkImage(userList[
                                                                  index]
                                                              .photoUrl !=
                                                          null
                                                      ? userList[index].photoUrl
                                                      : FirebaseService
                                                          .getProfileImage()),
                                                  fit: BoxFit.cover,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    offset:
                                                        new Offset(0.0, 0.0),
                                                    blurRadius: 2.0,
                                                    spreadRadius: 0.0,
                                                  ),
                                                ],
                                              ),
                                              height: 60,
                                              width:
                                                  getProportionateScreenWidth(
                                                      60),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width:
                                                  getProportionateScreenWidth(
                                                      200),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "${userList[index].firstName} ${userList[index].lastname.toUpperCase()}",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          userList[
                                                                          index]
                                                                      .verified ==
                                                                  "true"
                                                              ? Image.asset(
                                                                  "assets/images/ver_agent.png")
                                                              : SizedBox(
                                                                  height: 0)
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              'assets/images/agent rate.png'),
                                                          Text("5.0",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                      "${userList[index].city}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                                          "${userList[index].activities.toLowerCase()}",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.grey,
                                                          )),
                                                      Text(
                                                          "${userList[index].price}/${userList[index].unity.toLowerCase()}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
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
                                                  getProportionateScreenWidth(
                                                      190),
                                              margin: EdgeInsets.only(
                                                  right: 20, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                              margin: EdgeInsets.only(
                                                  left: 20, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                      agentTime == null &&
                                                              userList
                                                                  .isNotEmpty
                                                          ? "calculating ..."
                                                          : " ${agentTime[index]}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                            id: userList[index].id,
                                            time: agentTime == null &&
                                                    userList.isNotEmpty
                                                ? "calculating ..."
                                                : " ${agentTime[index]}",
                                          )),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )),
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutExpo,
                    left: 0,
                    right: 0,
                    bottom: this.soloPinPillPosition,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: 200,
                      child: ListView.builder(
                        itemCount: userList.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 50),
                        itemBuilder: (BuildContext context, int index) {
                          if (userList[index].id == agentLocationId)
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                231, 231, 231, 1)),
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
                                                    image: NetworkImage(userList[
                                                                    index]
                                                                .photoUrl !=
                                                            null
                                                        ? userList[index]
                                                            .photoUrl
                                                        : FirebaseService
                                                            .getProfileImage()),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      offset:
                                                          new Offset(0.0, 0.0),
                                                      blurRadius: 2.0,
                                                      spreadRadius: 0.0,
                                                    ),
                                                  ],
                                                ),
                                                height: 60,
                                                width:
                                                    getProportionateScreenWidth(
                                                        60),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                width:
                                                    getProportionateScreenWidth(
                                                        200),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "${userList[index].firstName} ${userList[index].lastname.toUpperCase()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            userList[
                                                                            index]
                                                                        .verified ==
                                                                    "true"
                                                                ? Image.asset(
                                                                    "assets/images/ver_agent.png")
                                                                : SizedBox(
                                                                    height: 0)
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                'assets/images/agent rate.png'),
                                                            Text("5.0",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                        "${userList[index].city}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                                            "${userList[index].activities.toLowerCase()}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              letterSpacing: 1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                                        Text(
                                                            "${userList[index].price}/${userList[index].unity.toLowerCase()}",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              letterSpacing: 1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.grey,
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
                                                    getProportionateScreenWidth(
                                                        190),
                                                margin: EdgeInsets.only(
                                                    right: 20, bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
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
                                                margin: EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                        agentTime == null &&
                                                                userList
                                                                    .isNotEmpty
                                                            ? "calculating ..."
                                                            : " ${agentTime[index]}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                              id: userList[index].id,
                                              time: agentTime == null &&
                                                      userList.isNotEmpty
                                                  ? "calculating ..."
                                                  : " ${agentTime[index]}",
                                            )),
                                  );
                                },
                              ),
                            );
                          return SizedBox(
                            width: 0,
                          );
                        },
                      ),
                    )),
                StreamBuilder(
                  stream: orderRef.doc(widget.orders).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      Orders orders = Orders.fromJson(snapshot.data.data());
                      locationData
                          .getCurrentCoordinatesName(
                              orders.startAt.latitude, orders.startAt.longitude)
                          .then((value) => setState(() {
                                startingTripLocationString = value;
                              }));
                      locationData
                          .getCurrentCoordinatesName(
                              orders.endAt.latitude, orders.endAt.longitude)
                          .then((value) => setState(() {
                                arriveTripLocationString = value;
                              }));
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 40, 20, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(
                                          context,
                                          p2 != null
                                              ? p2.description
                                              : arriveTripLocationString);
                                    },
                                    child: Image.asset(
                                      "assets/images/Back Arrow.png",
                                    ),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () =>
                                        _goToMyPosition(_controller.future),
                                    mini: true,
                                    elevation: 8,
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                        "assets/images/geolocate me.png"),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  onSurface: Colors.white,
                                  primary: Colors.white,
                                  onPrimary: Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  minimumSize: Size(100, 40), //////// HERE
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 220,
                                      child: Text(
                                        "$startingTripLocationString",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Image.asset(
                                        'assets/images/starting point.png')
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[400],
                              width: 250,
                            ),
                            Container(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  onSurface: Colors.white,
                                  primary: Colors.white,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  minimumSize: Size(100, 40), //////// HERE
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 220,
                                      child: Text(
                                        "$arriveTripLocationString",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Image.asset(
                                        'assets/images/arrival point.png')
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      height: 0,
                    );
                  },
                ),
                userList.length != 0
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 25),
                            child: Text("Show All",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllAgent(
                                          userList: userList,
                                          time: _info == null
                                              ? "calculating ..."
                                              : " ${_info.totalDuration}",
                                        )));
                          },
                        ))
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
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
                            color: Colors.grey[500],
                            offset: Offset(0.0, 1.5),
                            blurRadius: 1.5,
                          ),
                        ]),
                  ),
                ),
              ],
            );
          }
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: currentLocation, zoom: 14),
                  zoomControlsEnabled: false,
                  minMaxZoomPreference: MinMaxZoomPreference(6.5, 20.8),
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  markers: customMarkers,
                  mapToolbarEnabled: true,
                  onCameraMove: (CameraPosition positon) {
                    locationData.onCameraMove(positon);
                  },
                  onMapCreated: onCreate,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: userList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                      itemBuilder: (BuildContext context, int index) {
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
                                                    userList[index].photoUrl !=
                                                            null
                                                        ? userList[index]
                                                            .photoUrl
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
                                            height: 60,
                                            width:
                                                getProportionateScreenWidth(60),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: getProportionateScreenWidth(
                                                200),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "${userList[index].firstName} ${userList[index].lastname.toUpperCase()}",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              letterSpacing: 1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                        userList[
                                                                        index]
                                                                    .verified ==
                                                                "true"
                                                            ? Image.asset(
                                                                "assets/images/ver_agent.png")
                                                            : SizedBox(
                                                                height: 0)
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
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text("${userList[index].city}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
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
                                                        "${userList[index].activities.toLowerCase()}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.grey,
                                                        )),
                                                    Text(
                                                        "${userList[index].price}/${userList[index].unity.toLowerCase()}",
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
                                            width: getProportionateScreenWidth(
                                                190),
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
                                            margin: EdgeInsets.only(
                                                left: 20, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                    _info == null
                                                        ? "calculating ..."
                                                        : " ${_info.totalDuration}",
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AgentsDetails(
                                          id: userList[index].id,
                                          time: _info == null
                                              ? "calculating ..."
                                              : " ${_info.totalDuration}",
                                        )),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )),
              StreamBuilder(
                stream: orderRef.doc(widget.orders).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Orders orders = Orders.fromJson(snapshot.data.data());
                    locationData
                        .getCurrentCoordinatesName(
                            orders.startAt.latitude, orders.startAt.longitude)
                        .then((value) => setState(() {
                              startingTripLocationString = value;
                            }));
                    locationData
                        .getCurrentCoordinatesName(
                            orders.endAt.latitude, orders.endAt.longitude)
                        .then((value) => setState(() {
                              arriveTripLocationString = value;
                            }));
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 40, 20, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(
                                        context,
                                        p2 != null
                                            ? p2.description
                                            : arriveTripLocationString);
                                  },
                                  child: Image.asset(
                                    "assets/images/Back Arrow.png",
                                  ),
                                ),
                                FloatingActionButton(
                                  onPressed: () =>
                                      _goToMyPosition(_controller.future),
                                  mini: true,
                                  elevation: 8,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                      "assets/images/geolocate me.png"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                onSurface: Colors.white,
                                primary: Colors.white,
                                onPrimary: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                minimumSize: Size(100, 40), //////// HERE
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 220,
                                    child: Text(
                                      "$startingTripLocationString",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Image.asset(
                                      'assets/images/starting point.png')
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey[400],
                            width: 250,
                          ),
                          Container(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                onSurface: Colors.white,
                                primary: Colors.white,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                minimumSize: Size(100, 40), //////// HERE
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 220,
                                    child: Text(
                                      "$arriveTripLocationString",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Image.asset('assets/images/arrival point.png')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    height: 0,
                  );
                },
              ),
              userList.length != 0
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 25),
                          child: Text("Show All",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllAgent(
                                        userList: userList,
                                        time: _info == null
                                            ? "calculating ..."
                                            : " ${_info.totalDuration}",
                                      )));
                        },
                      ))
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
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
                          color: Colors.grey[500],
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.5,
                        ),
                      ]),
                ),
              ),
            ],
          );
        },
      )),
    );
  }

  Marker _createMarker(lat, lon, id) {
    setState(() {
      myIcon = id == firebaseAuth.currentUser.uid
          ? BitmapDescriptor.fromAsset("assets/images/mylocationmarker.png")
          : BitmapDescriptor.fromAsset("assets/images/agentselected.png");
    });
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, lon),
      draggable: false,
      onTap: () {
        setState(() {
          clicked = true;
          agentLocationId = id;
        });

        this.pinPillPosition = PIN_INVISIBLE_POSITION;
        this.soloPinPillPosition = PIN_VISIBLE_POSITION;
      },
      icon: myIcon,
    );
  }

  Future<void> _goToMyPosition(c) async {
    _myPosition = CameraPosition(
      target:
          LatLng(initPosition.target.latitude, initPosition.target.longitude),
      zoom: 14.5,
    );
    await locationData.getCurrentPosition();
    final GoogleMapController controller = await c;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myPosition));
  }

  Future<void> _goToPosition(c, latitude, longitude) async {
    _myPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 18.5,
    );
    await locationData.getCurrentPosition();
    final GoogleMapController controller = await c;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myPosition));
  }
}

class AllAgent extends StatefulWidget {
  static String routeName = '/AllAgent';
  final List<UserModel> userList;
  final String time;

  const AllAgent({Key key, this.userList, this.time}) : super(key: key);
  @override
  _AllAgentState createState() => _AllAgentState();
}

class _AllAgentState extends State<AllAgent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/pg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 40, 20, 5),
                          child: Image.asset(
                            "assets/images/Back Arrow.png",
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10, left: 20),
                    child: Text("All Agents",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.userList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 50),
                    itemBuilder: (BuildContext context, int index) {
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
                                              image: NetworkImage(widget
                                                          .userList[index]
                                                          .photoUrl !=
                                                      null
                                                  ? widget
                                                      .userList[index].photoUrl
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
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "${widget.userList[index].firstName} ${widget.userList[index].lastname.toUpperCase()}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          )),
                                                      widget.userList[index]
                                                                  .verified ==
                                                              "true"
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
                                              Text(
                                                  "${widget.userList[index].city}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                                      "${widget.userList[index].activities.toLowerCase()}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey,
                                                      )),
                                                  Text(
                                                      "${widget.userList[index].price}/${widget.userList[index].unity.toLowerCase()}",
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
                                              Text(" ${widget.time}",
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
                                        id: widget.userList[index].id,
                                        time: widget.time,
                                      )),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8, top: 10),
                    width: 135,
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
                ),
              ],
            ),
          ),
        ));
  }
}
