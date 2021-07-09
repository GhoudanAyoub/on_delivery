import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_delivery/SetUpProfile/UpdateProfile.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/custom_dropdown.dart';
import 'package:on_delivery/components/profile_pic.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/category.dart';
import 'package:on_delivery/services/auth_service.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';
import 'package:provider/provider.dart';

import '../block/navigation_block/navigation_block.dart';

class Profile extends StatefulWidget with NavigationStates {
  static String routeName = "/home";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _businessController = TextEditingController();
  TextEditingController ribController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController maxWeightController = TextEditingController();
  TextEditingController pricingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool moto = false, car = false;
  bool warehouseNo = true, warehouseYes = false;
  File userImage;
  String userImgLink, unity;
  final picker = ImagePicker();
  int _activeTab = 0;
  String CatName = "",
      startingPointString = "Starting Point",
      arrivalPointString = "Arrive Point";
  LocationProvider locationData;
  bool food = false, move = false, ecom = false, courier = false;

  List<Category> categories = [];

  List unityList = [
    'KG',
    'KM',
    'Miter',
    'Gram',
    'Unity',
  ];

  @override
  void initState() {
    FirebaseService().getCurrentUserData().then((value) => {
          _fNameController.text = value.firstName,
          _lNameController.text = value.lastname,
          _cityController.text = value.city,
          _phoneController.text = value.phone,
          _businessController.text = value.businessName,
          ribController.text = value.RIB,
          bankNameController.text = value.bankName,
          userImgLink = value.photoUrl,
          moto = value.transportType.toLowerCase().contains("moto"),
          car = !value.transportType.toLowerCase().contains("moto"),
          food = value.activities.toLowerCase().contains("food"),
          ecom = value.activities.toUpperCase().contains("E-COMMERCE"),
          move = value.activities.toLowerCase().contains("move"),
          courier = value.activities.toLowerCase().contains("courier"),
          startingPointString = "Starting Point",
          arrivalPointString = "Arrive Point",
          warehouseYes =
              value.wareHouse.toLowerCase().contains("yes") ? true : false,
          warehouseNo = !warehouseYes,
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/pg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                          child: Center(
                            child: GestureDetector(
                              onTap: () => pickImage(),
                              child: Container(
                                height: 100,
                                width: getProportionateScreenWidth(100),
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
                                child: userImgLink != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: ProfilePic(
                                          child: CircleAvatar(
                                            radius: 50.0,
                                            backgroundColor: Color.fromRGBO(
                                                239, 240, 246, 1),
                                            backgroundImage:
                                                NetworkImage(userImgLink),
                                          ),
                                        ))
                                    : userImage == null
                                        ? Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: ProfilePic(
                                              child: CircleAvatar(
                                                backgroundColor: Color.fromRGBO(
                                                    239, 240, 246, 1),
                                                radius: 50.0,
                                                backgroundImage: NetworkImage(
                                                    FirebaseService
                                                        .getProfileImage()),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: ProfilePic(
                                              child: CircleAvatar(
                                                radius: 50.0,
                                                backgroundColor: Color.fromRGBO(
                                                    239, 240, 246, 1),
                                                backgroundImage:
                                                    FileImage(userImage),
                                              ),
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        StreamBuilder(
                          stream: usersRef
                              .doc(firebaseAuth.currentUser.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              UserModel userModel =
                                  UserModel.fromJson(snapshot.data.data());

                              if (userModel.type
                                  .toLowerCase()
                                  .contains('agent')) {
                                categories = [
                                  Category(
                                    id: 1,
                                    name: "Personal",
                                  ),
                                  Category(
                                    id: 2,
                                    name: "Company",
                                  ),
                                  Category(
                                    id: 3,
                                    name: "Bank account",
                                  ),
                                ];
                              } else
                                categories = [
                                  Category(
                                    id: 1,
                                    name: "Personal",
                                  ),
                                ];
                              return Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 50,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _activeTab = index;
                                            CatName = categories[index]
                                                .name
                                                .toLowerCase();
                                            //search(CatName);
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 450),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                          height: 10,
                                          child: Column(
                                            children: [
                                              Text(
                                                categories[index].name,
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: _activeTab == index
                                                      ? Colors.black
                                                      : Colors.grey[400],
                                                ),
                                              ),
                                              _activeTab == index
                                                  ? Card(
                                                      elevation: 3,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: <Color>[
                                                              Color.fromRGBO(82,
                                                                  238, 79, 1),
                                                              Color.fromRGBO(
                                                                  5, 151, 0, 1)
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                      width: 0,
                                                    )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        width: 5.0,
                                      );
                                    },
                                    itemCount: categories.length,
                                  ),
                                ),
                              );
                            }
                            return Container(
                              height: 0,
                            );
                          },
                        ),
                        _activeTab == 0
                            ? Expanded(
                                child: ListView(
                                children: [
                                  SizedBox(height: 40),
                                  buildFNameFormField(),
                                  SizedBox(height: 30),
                                  buildLNameFormField(),
                                  SizedBox(height: 30),
                                  buildCityFormField(),
                                  SizedBox(height: 30),
                                  buildPhoneFormField(),
                                  SizedBox(height: 50),
                                ],
                              ))
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        _activeTab == 1
                            ? Expanded(
                                child: ListView(
                                children: [
                                  SizedBox(height: 10),
                                  TextFormBuilder(
                                    controller: _businessController,
                                    hintText: "Company",
                                    suffix: false,
                                    textInputAction: TextInputAction.next,
                                    validateFunction:
                                        Validations.validateBusinessName,
                                  ),
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Activities",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              food = !food;
                                            });
                                          },
                                          child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 64,
                                                width:
                                                    getProportionateScreenWidth(
                                                        120),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: food
                                                        ? [
                                                            Color.fromRGBO(255,
                                                                182, 40, 1),
                                                            Color.fromRGBO(
                                                                238, 71, 0, 1),
                                                          ]
                                                        : [
                                                            Color.fromRGBO(239,
                                                                240, 246, 1),
                                                            Color.fromRGBO(239,
                                                                240, 246, 1)
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
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
                                              move = !move;
                                            });
                                          },
                                          child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 64,
                                                width:
                                                    getProportionateScreenWidth(
                                                        120),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: move
                                                        ? [
                                                            Color.fromRGBO(255,
                                                                182, 40, 1),
                                                            Color.fromRGBO(
                                                                238, 71, 0, 1),
                                                          ]
                                                        : [
                                                            Color.fromRGBO(239,
                                                                240, 246, 1),
                                                            Color.fromRGBO(239,
                                                                240, 246, 1)
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
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
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ecom = !ecom;
                                            });
                                          },
                                          child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 64,
                                                width:
                                                    getProportionateScreenWidth(
                                                        120),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: ecom
                                                        ? [
                                                            Color.fromRGBO(255,
                                                                182, 40, 1),
                                                            Color.fromRGBO(
                                                                238, 71, 0, 1),
                                                          ]
                                                        : [
                                                            Color.fromRGBO(239,
                                                                240, 246, 1),
                                                            Color.fromRGBO(239,
                                                                240, 246, 1)
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
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
                                              courier = !courier;
                                            });
                                          },
                                          child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 64,
                                                width:
                                                    getProportionateScreenWidth(
                                                        120),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: courier
                                                        ? [
                                                            Color.fromRGBO(255,
                                                                182, 40, 1),
                                                            Color.fromRGBO(
                                                                238, 71, 0, 1),
                                                          ]
                                                        : [
                                                            Color.fromRGBO(239,
                                                                240, 246, 1),
                                                            Color.fromRGBO(239,
                                                                240, 246, 1)
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Means of transport",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              moto = false;
                                              car = true;
                                            });
                                          },
                                          child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 65,
                                                width: 75,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: car
                                                        ? [
                                                            Color.fromRGBO(
                                                                82, 238, 79, 1),
                                                            Color.fromRGBO(
                                                                5, 151, 0, 1),
                                                          ]
                                                        : [
                                                            Color.fromRGBO(239,
                                                                240, 246, 1),
                                                            Color.fromRGBO(239,
                                                                240, 246, 1)
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Car',
                                                      style: TextStyle(
                                                          color: car
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
                                              moto = true;
                                              car = false;
                                            });
                                          },
                                          child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 65,
                                                width: 75,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: moto
                                                        ? [
                                                            Color.fromRGBO(
                                                                82, 238, 79, 1),
                                                            Color.fromRGBO(
                                                                5, 151, 0, 1),
                                                          ]
                                                        : [
                                                            Color.fromRGBO(239,
                                                                240, 246, 1),
                                                            Color.fromRGBO(239,
                                                                240, 246, 1)
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Moto',
                                                      style: TextStyle(
                                                          color: moto
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
                                            setState(() {});
                                          },
                                          child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 65,
                                                width: 75,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.green),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.plus,
                                                      size: 30,
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                ),
                                              )))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: TextFormBuilder(
                                          controller: maxWeightController,
                                          hintText: "Max Weight",
                                          suffix: false,
                                          textInputAction: TextInputAction.next,
                                          validateFunction:
                                              Validations.validateNumber,
                                        ),
                                        width: getProportionateScreenWidth(140),
                                      ),
                                      Container(
                                        child: TextFormBuilder(
                                          controller: pricingController,
                                          hintText: "Pricing",
                                          suffix: false,
                                          prefix: CupertinoIcons.money_dollar,
                                          textInputAction: TextInputAction.next,
                                          validateFunction:
                                              Validations.validateNumber2,
                                        ),
                                        width: getProportionateScreenWidth(140),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomDropdown<int>(
                                    child: Text(
                                      'Unity',
                                    ),
                                    onChange: (int value, int index) => {
                                      setState(() {
                                        unity = unityList[index];
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
                                    items: [
                                      'KG',
                                      'KM',
                                      'Miter',
                                      'Gram',
                                      'Unity',
                                    ]
                                        .asMap()
                                        .entries
                                        .map(
                                          (item) => DropdownItem<int>(
                                            value: item.key + 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item.value,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //tripShit
                                  StreamBuilder(
                                    stream: usersRef
                                        .doc(firebaseAuth.currentUser.uid)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        UserModel userModel =
                                            UserModel.fromJson(
                                                snapshot.data.data());

                                        List<Widget> list = new List<Widget>();
                                        if (userModel.agentTripsLocationList !=
                                            null) {
                                          for (int e = 0;
                                              e <
                                                  userModel
                                                      .agentTripsLocationList
                                                      .length;
                                              e++) {
                                            list.add(Container(
                                                padding: EdgeInsets.all(10),
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          onSurface:
                                                              Colors.white,
                                                          primary: Colors
                                                              .transparent,
                                                          onPrimary:
                                                              Colors.white,
                                                          elevation: 4,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              topLeft: Radius
                                                                  .circular(10),
                                                            ),
                                                          ),
                                                          minimumSize: Size(100,
                                                              40), //////// HERE
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: 220,
                                                              child: Text(
                                                                userModel.agentTripsLocationList[
                                                                        e][
                                                                    "startingPointString"],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          elevation: 4,
                                                          onSurface:
                                                              Colors.white,
                                                          primary: Colors
                                                              .transparent,
                                                          onPrimary:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          minimumSize: Size(100,
                                                              40), //////// HERE
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: 220,
                                                              child: Text(
                                                                userModel.agentTripsLocationList[
                                                                        e][
                                                                    "arrivalPointString"],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ),
                                                            Image.asset(
                                                                'assets/images/arrival point.png')
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )));
                                          }

                                          return Column(
                                            children: list,
                                          );
                                        } else
                                          return Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
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
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        onSurface: Colors.white,
                                                        primary:
                                                            Colors.transparent,
                                                        onPrimary: Colors.white,
                                                        elevation: 4,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                        minimumSize: Size(100,
                                                            40), //////// HERE
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
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
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
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        elevation: 4,
                                                        onSurface: Colors.white,
                                                        primary:
                                                            Colors.transparent,
                                                        onPrimary: Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                        minimumSize: Size(100,
                                                            40), //////// HERE
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
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                          Image.asset(
                                                              'assets/images/arrival point.png')
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                      }
                                      return Container(
                                        height: 0,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/add another one.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await locationData
                                                .getCurrentPosition();
                                            if (locationData
                                                .permissionGranted) {
                                              Navigator.pushNamed(context,
                                                  MapTripScreen.routeName);
                                            }
                                          },
                                          child: Text("Update Trip",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    5, 151, 0, 1),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  //wareHouse Shit
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            warehouseYes = !warehouseYes;
                                            warehouseNo = !warehouseNo;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: warehouseYes
                                                    ? Colors.white
                                                    : Colors.grey
                                                        .withOpacity(0.3),
                                                border: Border.all(
                                                    color: warehouseYes
                                                        ? Colors.green
                                                        : Colors.grey
                                                            .withOpacity(0.3),
                                                    width:
                                                        warehouseYes ? 3 : 2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                null,
                                                size: 15.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Yes',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            warehouseYes = !warehouseYes;
                                            warehouseNo = !warehouseNo;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: warehouseNo
                                                    ? Colors.white
                                                    : Colors.grey
                                                        .withOpacity(0.3),
                                                border: Border.all(
                                                    color: warehouseNo
                                                        ? Colors.green
                                                        : Colors.grey
                                                            .withOpacity(0.3),
                                                    width: warehouseNo ? 3 : 2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                null,
                                                size: 15.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'No',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  StreamBuilder(
                                    stream: usersRef
                                        .doc(firebaseAuth.currentUser.uid)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        UserModel userModel =
                                            UserModel.fromJson(
                                                snapshot.data.data());

                                        List<Widget> list = new List<Widget>();
                                        if (userModel.wareHouseLocationList !=
                                            null) {
                                          for (int e = 0;
                                              e <
                                                  userModel
                                                      .wareHouseLocationList
                                                      .length;
                                              e++) {
                                            list.add(Column(
                                              children: [
                                                warehouseYes
                                                    ? Column(
                                                        children: [
                                                          Container(
                                                            height: 50.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        userModel.wareHouseLocationList[e]
                                                                            [
                                                                            "wareHouseAddress"],
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.grey[800],
                                                                          letterSpacing:
                                                                              1,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                      width:
                                                                          250,
                                                                    ),
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .house,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                              ],
                                            ));
                                          }

                                          return Column(
                                            children: list,
                                          );
                                        } else
                                          return Column(
                                            children: [
                                              warehouseYes
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/add another one.png",
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await locationData
                                                                  .getCurrentPosition();
                                                              if (locationData
                                                                  .permissionGranted) {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    MapScreen
                                                                        .routeName);
                                                              }
                                                            },
                                                            child: Text(
                                                                "Add warehouse Address",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          5,
                                                                          151,
                                                                          0,
                                                                          1),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                            ],
                                          );
                                      }
                                      return Container(
                                        height: 0,
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/add another one.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await locationData
                                                .getCurrentPosition();
                                            if (locationData
                                                .permissionGranted) {
                                              Navigator.pushNamed(
                                                  context, MapScreen.routeName);
                                            }
                                          },
                                          child: Text(
                                              "Update warehouse Address",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    5, 151, 0, 1),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ))
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        _activeTab == 2
                            ? Expanded(
                                child: ListView(
                                children: [
                                  SizedBox(height: 40),
                                  TextFormBuilder(
                                    controller: ribController,
                                    hintText: "RIB",
                                    suffix: false,
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
                                    textInputAction: TextInputAction.next,
                                    validateFunction:
                                        Validations.validateBankName,
                                  ),
                                  SizedBox(height: 50),
                                ],
                              ))
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              RaisedGradientButton(
                                  child: Text(
                                    'Save',
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
                                    // if (_formKey.currentState.validate()) {
                                    switch (_activeTab) {
                                      case 0:
                                        authService.updateUserDataToFireStore(
                                            firebaseAuth.currentUser,
                                            _fNameController.text,
                                            _lNameController.text,
                                            _cityController.text,
                                            _phoneController.text,
                                            userImage);
                                        break;
                                      case 1:
                                        authService.updateCompanyToFireStore(
                                            firebaseAuth.currentUser,
                                            "${food ? "FOOD," : ""}${move ? "MOVE," : ""}${courier ? "COURIER," : ""}${ecom ? "E-COMMERCE" : ""}",
                                            _businessController.text,
                                            moto ? "Moto" : "Car",
                                            maxWeightController.text,
                                            unity,
                                            pricingController.text);
                                        break;
                                      case 2:
                                        authService.updateRIBToFireStore(
                                            firebaseAuth.currentUser,
                                            ribController.text,
                                            bankNameController.text);
                                        break;
                                      default:
                                        showInSnackBar('Done');
                                        break;
                                    }
                                    Fluttertoast.showToast(
                                        msg: "Done",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    //  }
                                  }),
                              SizedBox(height: 10),
                              Container(
                                width: 135,
                                height: 5,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.grey[400],
                                        Colors.grey[400]
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
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }

  pickImage({bool camera = false}) async {
    loading = true;
    try {
      PickedFile pickedFile = await picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Color.fromRGBO(239, 240, 246, 1),
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      setState(() {
        userImage = File(croppedFile.path);
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showInSnackBar('Cancelled');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  buildFNameFormField() {
    return TextFormBuilder(
      controller: _fNameController,
      hintText: "First name",
      suffix: false,
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateName,
    );
  }

  buildLNameFormField() {
    return TextFormBuilder(
      controller: _lNameController,
      hintText: "Last name",
      suffix: false,
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateName,
    );
  }

  buildCityFormField() {
    return TextFormBuilder(
      controller: _cityController,
      hintText: "City",
      suffix: false,
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateName,
    );
  }

  buildPhoneFormField() {
    return TextFormBuilder(
      controller: _phoneController,
      suffix: false,
      hintText: "Phone Number",
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validatephone,
    );
  }
}
