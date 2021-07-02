import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:location/location.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/validation.dart';
import 'package:on_delivery/viewModel/EditProfileViewModel.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

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
  Location location = new Location();
  bool _serviceEnabled;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _fNameContoller = TextEditingController();
  TextEditingController _lNameContoller = TextEditingController();
  TextEditingController _cityContoller = TextEditingController();
  TextEditingController _phoneContoller = TextEditingController();
  TextEditingController _businessController = TextEditingController();
  TextEditingController maxWeightController = TextEditingController();
  TextEditingController startingPointController = TextEditingController();
  TextEditingController arrivalPointController = TextEditingController();
  TextEditingController ribController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  String _verificationCode;
  String _verificationSelected, _businessSelected;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  LocationProvider locationData;
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
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context);
    EditProfileViewModel viewModel = Provider.of<EditProfileViewModel>(context);

    return Stack(
      children: [
        if (valid) validPhone(),
        if (widget.Type && agentInt) agentInterface(viewModel),
        if (!widget.Type) clientInterface(viewModel),
        if (verificationMth) verificationMethod(),
        if (businessInt) businessInterface(),
        if (activityInt) activityInterface(),
        if (tripLocationInt) tripLocationInterface(),
        if (ribBankInt) ribBankInterface(),
      ],
    );
  }

  agentInterface(viewModel) {
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
                                  onTap: () => viewModel.pickImage(),
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
                                    child: viewModel.imgLink != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundColor: Color.fromRGBO(
                                                  239, 240, 246, 1),
                                              backgroundImage: NetworkImage(
                                                  viewModel.imgLink),
                                            ),
                                          )
                                        : viewModel.image == null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          239, 240, 246, 1),
                                                  radius: 30.0,
                                                  backgroundImage: NetworkImage(
                                                      "widget.user.photoUrl"),
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
                                                  backgroundImage: FileImage(
                                                      viewModel.image),
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
                                    setState(() {
                                      valid = true;
                                      agentInt = false;
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
                                  width: 120,
                                  child: LiteRollingSwitch(
                                    value: locationState,
                                    textOn: 'GPS',
                                    textOff: 'Off',
                                    colorOn: Colors.greenAccent[700],
                                    colorOff: Colors.grey,
                                    iconOn: CupertinoIcons.location,
                                    iconOff: CupertinoIcons.nosign,
                                    textSize: 12.0,
                                    onChanged: (bool state) async {
                                      if (state) {
                                        /* _serviceEnabled =
                                          await location.serviceEnabled();
                                      if (!_serviceEnabled) {
                                        _serviceEnabled =
                                            await location.requestService();
                                        if (!_serviceEnabled) {
                                          debugPrint('Location Denied once');
                                        }
                                      }*/
                                        setState(() {
                                          locationState = state;
                                        });
                                        locationData.getCurrentPosition();
                                        print(
                                            'Current State of SWITCH IS: $state ${locationData.lng}');
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                                child: Column(
                              children: [
                                TextField(
                                  controller: startingPointController,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        CupertinoIcons.location_fill,
                                        size: 20.0,
                                        color: Colors.green,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(224, 224, 224, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(224, 224, 224, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(224, 224, 224, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 20),
                                      labelText: 'Starting point'),
                                ),
                                TextField(
                                  controller: arrivalPointController,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        CupertinoIcons.location,
                                        size: 20.0,
                                        color: Colors.green,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(224, 224, 224, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(224, 224, 224, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(224, 224, 224, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 20),
                                      labelText: 'Arrival point'),
                                ),
                              ],
                            )),
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
                            TextFormBuilder(
                              controller: maxWeightController,
                              hintText: "Max Weight",
                              suffix: false,
                              prefix: CupertinoIcons.arrow_up_down,
                              textInputAction: TextInputAction.next,
                              validateFunction: Validations.validateNumber,
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
                                warehouseYes
                                    ? Container(
                                        height: 50.0,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {},
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        child: Text(
                                                      "Add warehouse address",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[800],
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    )),
                                                    Icon(
                                                      CupertinoIcons.house,
                                                      size: 20,
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                        width: 0,
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
                                          onTap: () {},
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
                                              onTap: () {},
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
                                              onTap: () {},
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
                                    setState(() {
                                      valid = false;
                                      agentInt = false;
                                      businessInt = true;
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
                                "We sent SMS verification code\non number : ${_phoneContoller.text.toLowerCase()}",
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
                                await FirebaseAuth.instance
                                    .signInWithCredential(
                                        PhoneAuthProvider.credential(
                                            verificationId: _verificationCode,
                                            smsCode: pin))
                                    .then((value) async {
                                  if (value.user != null) {
                                    setState(() {
                                      verificationMth = true;
                                    });
                                  }
                                });
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
                                  onTap: () => {},
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
        phoneNumber: '${_phoneContoller.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              /*
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false);*/
            }
          });
        },
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

  clientInterface(viewModel) {
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
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.all(50),
                    child: ListView(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () => viewModel.pickImage(),
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
                              child: viewModel.imgLink != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: CircleAvatar(
                                        radius: 65.0,
                                        backgroundColor:
                                            Color.fromRGBO(239, 240, 246, 1),
                                        backgroundImage:
                                            NetworkImage(viewModel.imgLink),
                                      ),
                                    )
                                  : viewModel.image == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            backgroundColor: Color.fromRGBO(
                                                239, 240, 246, 1),
                                            radius: 65.0,
                                            backgroundImage: NetworkImage(
                                                "widget.user.photoUrl"),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            radius: 65.0,
                                            backgroundColor: Color.fromRGBO(
                                                239, 240, 246, 1),
                                            backgroundImage:
                                                FileImage(viewModel.image),
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
      controller: _fNameContoller,
      hintText: "First name",
      suffix: false,
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateName,
    );
  }

  buildLNameFormField() {
    return TextFormBuilder(
      controller: _lNameContoller,
      hintText: "Last name",
      suffix: false,
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateName,
    );
  }

  buildCityFormField() {
    return TextFormBuilder(
      controller: _cityContoller,
      hintText: "City",
      suffix: false,
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateName,
    );
  }

  buildPhoneFormField() {
    return TextFormBuilder(
      controller: _phoneContoller,
      suffix: false,
      hintText: "Phone Number",
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validatephone,
    );
  }
}
