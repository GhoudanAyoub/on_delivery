import 'dart:async';
import 'dart:collection';
import 'dart:io';

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
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/home/base.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/services/auth_service.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

String kGoogleApiKey = Platform.isAndroid
    ? "AIzaSyD3exTbi5W-6kYICekpUEslE3gIcSF5weI"
    : "AIzaSyDvpynTkP9xyNU8KO4UlJYWlQfn-trjeGw";

class UpdateProfiles extends StatefulWidget {
  static String routeName = "/UpdateProfiles";
  final bool Type;

  const UpdateProfiles({Key key, this.Type}) : super(key: key);
  @override
  _UpdateProfilesState createState() => _UpdateProfilesState();
}

class _UpdateProfilesState extends State<UpdateProfiles> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _ribFormKey = GlobalKey<FormState>();
  final _tripFormKey = GlobalKey<FormState>();
  final _activitiesFormKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();
  final _clientFormKey = GlobalKey<FormState>();
  final _verificationFormKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  var submitted = false;
  int types = 0;
  bool verificationMth = false;
  bool valid = false;
  bool agentInt = true;
  bool passport = false;
  bool identityCard = false;
  bool businessInt = false;
  bool activityInt = false;
  bool tripLocationInt = false;
  bool ribBankInt = false;
  bool moto = false, car = false;
  bool warehouseNo = true, warehouseYes = false;
  bool food = false, move = false, ecom = false, courier = false;
  bool locationState = false;
  bool validate = false;
  bool loading = false,
      loadingSide1 = false,
      loadingSide2 = false,
      loadingPassprot = false;
  bool _serviceEnabled;

  File userImage;
  File side1Image;
  File side2Image;
  File passportImage;
  String userImgLink,
      startingPointString = "Starting Point",
      arrivalPointString = "Arrive Point";

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _businessController = TextEditingController();
  TextEditingController maxWeightController = TextEditingController();
  TextEditingController startingPointController = TextEditingController();
  TextEditingController arrivalPointController = TextEditingController();
  TextEditingController ribController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  String _verificationCode;
  String _verificationSelected, _businessSelected, _unitiSelected;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  LocationProvider locationData;
  final picker = ImagePicker();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Color.fromRGBO(239, 240, 246, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context, listen: false);

    return Stack(
      children: [
        if (valid) validPhone(),
        if (widget.Type && agentInt) agentInterface(),
        if (!widget.Type) clientInterface(),
        if (verificationMth) verificationMethod(),
        if (businessInt) businessInterface(),
        if (activityInt) activityInterface(),
        if (tripLocationInt) tripLocationInterface(),
        if (ribBankInt) ribBankInterface(),
      ],
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

  pickImageSide1({bool camera = false}) async {
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
        side1Image = File(croppedFile.path);
        loadingSide1 = true;
      });
    } catch (e) {
      setState(() {
        loadingSide1 = false;
      });
      showInSnackBar('Cancelled');
    }
  }

  pickImageSide2({bool camera = false}) async {
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
        side2Image = File(croppedFile.path);
        loadingSide2 = true;
      });
    } catch (e) {
      setState(() {
        loadingSide2 = false;
      });
      showInSnackBar('Cancelled');
    }
  }

  pickImagePassport({bool camera = false}) async {
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
        passportImage = File(croppedFile.path);
        loadingPassprot = true;
      });
    } catch (e) {
      setState(() {
        loadingPassprot = false;
      });
      showInSnackBar('Cancelled');
    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  agentInterface() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              leading: IconButton(
                icon:
                    Icon(Icons.arrow_back, color: Color.fromRGBO(5, 151, 0, 1)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Align(
                alignment: Alignment.topRight,
                child: Text("Setup profile",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              ),
            ),
            body: Form(
                key: _formKey,
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
                        Expanded(
                            child: ListView(
                          children: [
                            Center(
                                child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => pickImage(),
                                  child: Container(
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
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundColor: Color.fromRGBO(
                                                  239, 240, 246, 1),
                                              backgroundImage:
                                                  NetworkImage(userImgLink),
                                            ),
                                          )
                                        : userImage == null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          239, 240, 246, 1),
                                                  radius: 30.0,
                                                  backgroundImage: NetworkImage(
                                                      FirebaseService
                                                          .getProfileImage()),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          239, 240, 246, 1),
                                                  backgroundImage:
                                                      FileImage(userImage),
                                                ),
                                              ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                      "Add your profile picture.\nMake sure it doesn't pass the\nsize of 1mo.",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
                                      )),
                                )
                              ],
                            )),
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
                        )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                              SizedBox(height: 20),
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
                                    if (_formKey.currentState.validate()) {
                                      authService.updateUserDataToFireStore(
                                          firebaseAuth.currentUser,
                                          _fNameController.text,
                                          _lNameController.text,
                                          _cityController.text,
                                          _phoneController.text,
                                          userImage);

                                      _verifyPhone();
                                      setState(() {
                                        valid = true;
                                        agentInt = false;
                                      });
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
                        )
                      ],
                    ),
                  ),
                ))));
  }

  ribBankInterface() {
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
                  child: Text("Setup profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _ribFormKey,
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
                              "Please provide your RIB to help your clients pay you easily",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              )),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Expanded(
                            child: ListView(
                          children: [
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
                              validateFunction: Validations.validateBankName,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                              SizedBox(height: 20),
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
                                    authService.updateRIBToFireStore(
                                        firebaseAuth.currentUser,
                                        ribController.text,
                                        bankNameController.text);
                                    Navigator.pushNamed(
                                        context, Base.routeName);
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

  tripLocationInterface() {
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
                  child: Text("Setup profile",
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
                              "What are your trips, the max weight and your RIB ?",
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
                                  child: Text("Turn on my gps",
                                      textAlign: TextAlign.center,
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
                                      if (state)
                                        locationData.getCurrentPosition();
                                      setState(() {
                                        locationState = state;
                                        locationData.getMoveCamera().then(
                                            (value) => startingPointController
                                                .text = value);
                                      });
                                    },
                                  ),

                                  /* LiteRollingSwitch(
                                      value: locationState,
                                      textOn: 'GPS',
                                      textOff: 'Off',
                                      colorOn: Colors.greenAccent[700],
                                      colorOff: Colors.grey,
                                      iconOn: CupertinoIcons.location,
                                      iconOff: CupertinoIcons.nosign,
                                      textSize: 12.0,
                                      onChanged: (bool state) async {
                                        if (state)
                                          locationData.getCurrentPosition();
                                        setState(() {
                                          locationState = state;
                                        });
                                      }),*/
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            StreamBuilder(
                              stream: usersRef
                                  .doc(firebaseAuth.currentUser.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  UserModel userModel =
                                      UserModel.fromJson(snapshot.data.data());

                                  List<Widget> list = new List<Widget>();
                                  if (userModel.agentTripsLocationList !=
                                      null) {
                                    for (int e = 0;
                                        e <
                                            userModel
                                                .agentTripsLocationList.length;
                                        e++) {
                                      list.add(Container(
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    onSurface: Colors.white,
                                                    primary: Colors.transparent,
                                                    onPrimary: Colors.white,
                                                    elevation: 4,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    minimumSize: Size(
                                                        100, 40), //////// HERE
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 4,
                                                    onSurface: Colors.white,
                                                    primary: Colors.transparent,
                                                    onPrimary: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    minimumSize: Size(
                                                        100, 40), //////// HERE
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                style: ElevatedButton.styleFrom(
                                                  onSurface: Colors.white,
                                                  primary: Colors.transparent,
                                                  onPrimary: Colors.white,
                                                  elevation: 4,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  minimumSize: Size(
                                                      100, 40), //////// HERE
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.black,
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
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 4,
                                                  onSurface: Colors.white,
                                                  primary: Colors.transparent,
                                                  onPrimary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  minimumSize: Size(
                                                      100, 40), //////// HERE
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.black,
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
                              height: 40,
                            ),
                            Row(
                              children: [
                                Icon(CupertinoIcons.plus_circle_fill,
                                    size: 20, color: Colors.green),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Add another trip",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.green,
                                    )),
                              ],
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
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
                              SizedBox(height: 20),
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
                                    authService.updateTripsmaxWeightToFireStore(
                                        firebaseAuth.currentUser,
                                        maxWeightController.text);
                                    setState(() {
                                      valid = false;
                                      agentInt = false;
                                      businessInt = false;
                                      activityInt = false;
                                      tripLocationInt = false;
                                      ribBankInt = true;
                                    });
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
                  child: Text("Setup profile",
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
                          child:
                              Text("What activity/activities do you provide?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700],
                                  )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text("You can select more than one",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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
                                        food = !food;
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
                                        move = !move;
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
                                        ecom = !ecom;
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
                                        courier = !courier;
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
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                              SizedBox(height: 20),
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
                                    authService.updateActivitiesToFireStore(
                                        firebaseAuth.currentUser,
                                        "${food ? "FOOD/" : ""}${move ? "MOVE/" : ""}${courier ? "COURIER/" : ""}${ecom ? "E-COMMERCE" : ""}");
                                    setState(() {
                                      valid = false;
                                      agentInt = false;
                                      businessInt = false;
                                      activityInt = false;
                                      tripLocationInt = true;
                                    });
                                  }),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }

  businessInterface() {
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
                  child: Text("Setup profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _businessFormKey,
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
                              "To more information you give about your business the more you are trusted",
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
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(239, 240, 246, 1),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          isDense: true,
                                          hint: new Text("Company,person "),
                                          value: _businessSelected,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _businessSelected = newValue;
                                            });
                                          },
                                          items: ["Company", "Person"]
                                              .map((e) => new DropdownMenuItem(
                                                    value: e.toString(),
                                                    // value: _mySelection,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                            CupertinoIcons
                                                                .keyboard_chevron_compact_down,
                                                            size: 20,
                                                            color:
                                                                Colors.black87),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Text(
                                                              e,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormBuilder(
                              controller: _businessController,
                              hintText: "Business name",
                              suffix: false,
                              textInputAction: TextInputAction.next,
                              validateFunction:
                                  Validations.validateBusinessName,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Means of transport",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
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
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
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
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
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
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
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
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("You have a warehouse?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800],
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                                                  width: warehouseYes ? 3 : 2),
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
                                            style:
                                                TextStyle(color: Colors.black),
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
                                            style:
                                                TextStyle(color: Colors.black),
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
                                      UserModel userModel = UserModel.fromJson(
                                          snapshot.data.data());

                                      List<Widget> list = new List<Widget>();
                                      if (userModel.wareHouseLocationList !=
                                          null) {
                                        for (int e = 0;
                                            e <
                                                userModel.wareHouseLocationList
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
                                                            color: Colors.white,
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
                                                                    child: Text(
                                                                      userModel.wareHouseLocationList[
                                                                              e]
                                                                          [
                                                                          "wareHouseAddress"],
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey[800],
                                                                        letterSpacing:
                                                                            1,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    width: 250,
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
                                                          height: 20,
                                                        ),
                                                        Align(
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
                                                                onTap:
                                                                    () async {
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
                                                                    "Update warehouse Address",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
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
                                                              style: TextStyle(
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
                              ],
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                              SizedBox(height: 20),
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
                                    authService.updateBusinessDataToFireStore(
                                        firebaseAuth.currentUser,
                                        _businessSelected,
                                        _businessController.text,
                                        moto ? "Moto" : "Car",
                                        warehouseYes ? "Yes" : "No");

                                    setState(() {
                                      valid = false;
                                      agentInt = false;
                                      businessInt = false;
                                      activityInt = true;
                                    });
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

  verificationMethod() {
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
                  child: Text("Setup profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _verificationFormKey,
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
                        Expanded(
                            child: ListView(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                  "To protect everyone from fraud and scam and to have a better chance working with client please provide your id",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700],
                                  )),
                            ),
                            SizedBox(height: 40),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(239, 240, 246, 1),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          isDense: true,
                                          hint: new Text(
                                              "Choose your verification methode"),
                                          value: _verificationSelected,
                                          onChanged: (String newValue) {
                                            if (newValue
                                                .contains("Identity card"))
                                              setState(() {
                                                _verificationSelected =
                                                    newValue;
                                                identityCard = true;
                                                passport = false;
                                              });
                                            else {
                                              setState(() {
                                                _verificationSelected =
                                                    newValue;
                                                identityCard = false;
                                                passport = true;
                                              });
                                            }
                                          },
                                          items: ["Identity card ", "Passport"]
                                              .map((e) => new DropdownMenuItem(
                                                    value: e.toString(),
                                                    // value: _mySelection,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                            CupertinoIcons
                                                                .cloud_upload,
                                                            size: 20,
                                                            color:
                                                                Colors.black87),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Text(
                                                              e,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Column(
                              children: [
                                if (passport)
                                  Container(
                                    width: SizeConfig.screenWidth,
                                    height: 50.0,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(239, 240, 246, 1),
                                            Color.fromRGBO(239, 240, 246, 1)
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
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () => pickImagePassport(),
                                          child: Center(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                    CupertinoIcons.cloud_upload,
                                                    size: 20,
                                                    color: Colors.black87),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "Upload Passport",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                loadingPassprot
                                                    ? Icon(
                                                        CupertinoIcons
                                                            .check_mark,
                                                        size: 20,
                                                        color: Colors.green)
                                                    : Container(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                if (identityCard)
                                  Column(
                                    children: [
                                      Container(
                                        width: SizeConfig.screenWidth,
                                        height: 50.0,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                Color.fromRGBO(
                                                    239, 240, 246, 1),
                                                Color.fromRGBO(239, 240, 246, 1)
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
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () => pickImageSide1(),
                                              child: Center(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                        CupertinoIcons
                                                            .cloud_upload,
                                                        size: 20,
                                                        color: Colors.black87),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        child: Text(
                                                          "Upload identity card Side1",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    loadingSide1
                                                        ? Icon(
                                                            CupertinoIcons
                                                                .check_mark,
                                                            size: 20,
                                                            color: Colors.green)
                                                        : Container(
                                                            height: 0,
                                                            width: 0,
                                                          ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: SizeConfig.screenWidth,
                                        height: 50.0,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                Color.fromRGBO(
                                                    239, 240, 246, 1),
                                                Color.fromRGBO(239, 240, 246, 1)
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
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () => pickImageSide2(),
                                              child: Center(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                        CupertinoIcons
                                                            .cloud_upload,
                                                        size: 20,
                                                        color: Colors.black87),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        child: Text(
                                                          "Upload identity card Side2",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    loadingSide2
                                                        ? Icon(
                                                            CupertinoIcons
                                                                .check_mark,
                                                            size: 20,
                                                            color: Colors.green)
                                                        : Container(
                                                            height: 0,
                                                            width: 0,
                                                          ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color.fromRGBO(82, 238, 79, 1),
                                            Color.fromRGBO(5, 151, 0, 1)
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                                  Container(
                                    width: 40,
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
                              SizedBox(height: 20),
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
                                    if (loadingPassprot == true ||
                                        (loadingSide1 == true &&
                                            loadingSide2 == true)) {
                                      authService
                                          .updateVerificationDataToFireStore(
                                              firebaseAuth.currentUser,
                                              _verificationSelected
                                                  .toLowerCase(),
                                              side1Image,
                                              side2Image,
                                              passportImage);
                                      setState(() {
                                        valid = false;
                                        agentInt = false;
                                        businessInt = true;
                                      });
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
                        )
                      ],
                    ),
                  ),
                ))));
  }

  validPhone() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              leading: Padding(
                  padding: EdgeInsets.only(right: 30, top: 40),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromRGBO(5, 151, 0, 1)),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              title: Padding(
                padding: EdgeInsets.only(right: 30, top: 40),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("Setup profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            body: Form(
                key: _formKey,
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
                    height: double.infinity,
                    padding: EdgeInsets.fromLTRB(0, 100, 0, 20),
                    child: Stack(
                      children: [
                        Positioned(
                            top: 20,
                            right: 10,
                            left: 10,
                            child: Container(
                              child: Text(
                                "We sent SMS verification code\non number : ${_phoneController.text.toLowerCase()}",
                                textAlign: TextAlign.center,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 100, 5, 20),
                          child: PinPut(
                            fieldsCount: 6,
                            textStyle: const TextStyle(
                                fontSize: 25.0, color: Colors.black),
                            eachFieldWidth: 60.0,
                            eachFieldHeight: 60.0,
                            focusNode: _pinPutFocusNode,
                            controller: _pinPutController,
                            submittedFieldDecoration: pinPutDecoration,
                            selectedFieldDecoration: pinPutDecoration,
                            followingFieldDecoration: pinPutDecoration,
                            pinAnimationType: PinAnimationType.rotation,
                            onSubmit: (pin) async {
                              try {
                                /*
                                await FirebaseAuth.instance
                                    .signInWithCredential(
                                        PhoneAuthProvider.credential(
                                            verificationId: _verificationCode,
                                            smsCode: pin))
                                    .then((value) async {
                                  if (_verificationCode == pin) {
                                    setState(() {
                                      verificationMth = true;
                                    });
                                  }
                                });*/
                                AuthCredential _credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationCode,
                                        smsCode: pin);

                                if (_credential != null) {
                                  setState(() {
                                    verificationMth = true;
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  verificationMth = true;
                                });
                                FocusScope.of(context).unfocus();
                                _scaffoldkey.currentState.showSnackBar(
                                    SnackBar(content: Text('invalid OTP')));
                              }
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          right: 10,
                          left: 10,
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                                child: GestureDetector(
                                  onTap: () => {
                                    setState(() {
                                      valid = false;
                                      agentInt = true;
                                    })
                                  },
                                  child: Text(
                                    "Change Number?",
                                    style: TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Color.fromRGBO(0, 0, 0, 0.25)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                                child: GestureDetector(
                                  onTap: () => _verifyPhone(),
                                  child: Text(
                                    "Resend the code",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        letterSpacing: 1,
                                        color: Color.fromRGBO(82, 238, 79, 1)),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        )
                      ],
                    ),
                  ),
                ))));
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${_phoneController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  clientInterface() {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              leading: IconButton(
                icon:
                    Icon(Icons.arrow_back, color: Color.fromRGBO(5, 151, 0, 1)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Align(
                alignment: Alignment.topRight,
                child: Text("Setup profile",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              ),
            ),
            body: Form(
                key: _clientFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.all(50),
                    child: ListView(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () => pickImage(),
                            child: Container(
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
                                      child: CircleAvatar(
                                        radius: 65.0,
                                        backgroundColor:
                                            Color.fromRGBO(239, 240, 246, 1),
                                        backgroundImage:
                                            NetworkImage(userImgLink),
                                      ),
                                    )
                                  : userImage == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            backgroundColor: Color.fromRGBO(
                                                239, 240, 246, 1),
                                            radius: 65.0,
                                            backgroundImage: NetworkImage(
                                                firebaseAuth
                                                    .currentUser.photoURL),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            radius: 65.0,
                                            backgroundColor: Color.fromRGBO(
                                                239, 240, 246, 1),
                                            backgroundImage:
                                                FileImage(userImage),
                                          ),
                                        ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        buildFNameFormField(),
                        SizedBox(height: 30),
                        buildLNameFormField(),
                        SizedBox(height: 30),
                        buildCityFormField(),
                        SizedBox(height: 30),
                        buildPhoneFormField(),
                        SizedBox(height: 50),
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
                              if (_clientFormKey.currentState.validate()) {
                                authService.updateUserDataToFireStore(
                                    firebaseAuth.currentUser,
                                    _fNameController.text,
                                    _lNameController.text,
                                    _cityController.text,
                                    _phoneController.text,
                                    userImage);
                              }
                              /* Navigator.pushNamed(
                                  context, UpdateProfiles.routeName);*/
                            }),
                      ],
                    ),
                  ),
                ))));
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

class MapScreen extends StatefulWidget {
  static String routeName = '/MapScreen';
  final User user;

  const MapScreen({Key key, this.user}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationProvider locationData;
  LatLng currentLocation;
  GoogleMapController _mapController;
  TextEditingController wareHouseLocationController = TextEditingController();
  AuthService authService = AuthService();
  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _myPosition;
  static CameraPosition initPosition;
  String controllerLocationString = "Warehouse";
  PlacesDetailsResponse detail;
  Prediction p;
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  double searchedLocationLnt, searchedLocationLng;
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
                      controllerLocationString = value;
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
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        minimumSize: Size(100, 40), //////// HERE
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 250,
                            child: Text(
                              controllerLocationString,
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
                      onPressed: _handlePressButton,
                    ),
                  )
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
                          "wareHouseAddress",
                          () => p != null
                              ? p.description
                              : controllerLocationString);
                      agentTripsLocationList.putIfAbsent(
                          "wareHousePosition",
                          () => GeoPoint(
                              locationData.lnt != null
                                  ? locationData.lnt
                                  : searchedLocationLnt,
                              locationData.lng != null
                                  ? locationData.lng
                                  : searchedLocationLnt));
                      List<HashMap<String, dynamic>> list = [];
                      list.add(agentTripsLocationList);
                      authService.updateBusinessLocationToFireStore(
                          widget.user, list, "Yes");
                      /*authService.addNewBusinessLocationToFireStore(
                          widget.user, agentTripsLocationList, "Yes");*/

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
    p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      hint: 'Search WareHouse',
      onError: onError,
      language: "fr",
      overlayBorderRadius: BorderRadius.all(Radius.circular(10)),
      components: [Component(Component.country, "mar")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      setState(() {
        searchedLocationLnt = detail.result.geometry.location.lat;
        searchedLocationLng = detail.result.geometry.location.lng;
        controllerLocationString = p.description;
      });
      _goToPosition(
          _controller.future, searchedLocationLnt, searchedLocationLng);
    }
  }
}

class MapTripScreen extends StatefulWidget {
  static String routeName = '/MapTripScreen';
  final User user;

  const MapTripScreen({Key key, this.user}) : super(key: key);
  @override
  _MapTripScreenState createState() => _MapTripScreenState();
}

class _MapTripScreenState extends State<MapTripScreen> {
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
                      authService.updateTripsLocationToFireStore(
                          widget.user, list);
                      /* authService.addNewTripsLocationToFireStore(
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
