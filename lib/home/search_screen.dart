import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:on_delivery/SetUpProfile/UpdateProfile.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/custom_dropdown.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/services/auth_service.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/validation.dart';
import 'package:provider/provider.dart';

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
      transport;

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
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
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
                                          height: 133,
                                          width: 133,
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
                                          height: 133,
                                          width: 133,
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
                                          height: 133,
                                          width: 133,
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
                                          height: 133,
                                          width: 133,
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
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
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
                                    Navigator.pushNamed(
                                        context, MapTripScreen.routeName);
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
                                          width: 300,
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
                                                  width: 220,
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
                                          width: 300,
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
                                                  width: 220,
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
                                  onPressed: () async {}),
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
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
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
                                    Navigator.pushNamed(
                                        context, MapTripScreen.routeName);
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
                                          width: 300,
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
                                                  width: 220,
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
                                          width: 300,
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
                                                  width: 220,
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
                                  onPressed: () async {}),
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
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
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
                                    Navigator.pushNamed(
                                        context, MapTripScreen.routeName);
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
                                          width: 300,
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
                                                  width: 220,
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
                                          width: 300,
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
                                                  width: 220,
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
                                  onPressed: () async {}),
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
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
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
                                    Navigator.pushNamed(
                                        context, MapTripScreen.routeName);
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
                                          width: 300,
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
                                                  width: 220,
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
                                          width: 300,
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
                                                  width: 220,
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
                                  onPressed: () async {}),
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
      setState(() async {
        _controller.complete(controller);
        _mapController = controller;
        initPosition =
            CameraPosition(target: LatLng(locationData.lnt, locationData.lng));
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/images/Back Arrow.png",
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () => _goToMyPosition(_controller.future),
                          mini: true,
                          elevation: 8,
                          backgroundColor: Colors.white,
                          child: Image.asset("assets/images/geolocate me.png"),
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
                      Map<String, dynamic> agentTripsLocationList =
                          new HashMap();
                      agentTripsLocationList.putIfAbsent(
                          "startingPointString",
                          () => p != null
                              ? p.description
                              : startingTripLocationString);
                      agentTripsLocationList.putIfAbsent(
                          "arrivalPointString",
                          () => p2 != null
                              ? p2.description
                              : arriveTripLocationString);
                      agentTripsLocationList.putIfAbsent(
                          "arrivalPoint",
                          () => GeoPoint(
                              locationData.lnt != null
                                  ? locationData.lnt
                                  : arrivedLocationLnt,
                              locationData.lng != null
                                  ? locationData.lng
                                  : arrivedLocationLng));
                      agentTripsLocationList.putIfAbsent(
                          "startingPoint",
                          () => GeoPoint(
                              locationData.lnt != null
                                  ? locationData.lnt
                                  : startingLocationLnt,
                              locationData.lng != null
                                  ? locationData.lng
                                  : startingLocationLng));
                      List<HashMap<String, dynamic>> list = [];
                      list.add(agentTripsLocationList);
                      /* authService.updateTripsLocationToFireStore(
                          widget.user, list);
                       authService.addNewTripsLocationToFireStore(
                          widget.user, agentTripsLocationList);*/
                      Navigator.pop(context);
                    }),
              ),
            )
          ],
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
