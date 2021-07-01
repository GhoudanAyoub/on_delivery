import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/text_form_builder.dart';
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

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _fNameContoller = TextEditingController();
  TextEditingController _lNameContoller = TextEditingController();
  TextEditingController _cityContoller = TextEditingController();
  TextEditingController _phoneContoller = TextEditingController();
  String _verificationCode;
  String _selected;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
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
    EditProfileViewModel viewModel = Provider.of<EditProfileViewModel>(context);

    return Stack(
      children: [
        if (valid) validPhone(),
        if (widget.Type && agentInt) agentInterface(viewModel),
        if (!widget.Type) clientInterface(viewModel),
        if (verificationMth) verificationMethod(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  borderRadius: BorderRadius.circular(10.0),
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
                            Container(
                              width: 40,
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
                            Container(
                              width: 40,
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
                            Container(
                              width: 40,
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
                            Container(
                              width: 40,
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
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    padding: EdgeInsets.all(50),
                    child: Stack(
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
                        Positioned(
                          top: 300,
                          left: 2,
                          right: 2,
                          child: Column(
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
                                        onTap: () {},
                                        child: Center(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(CupertinoIcons.cloud_upload,
                                                  size: 20,
                                                  color: Colors.black87),
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
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
                                                              FontWeight.normal,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
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
                                                              FontWeight.normal,
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
                        ),
                        Positioned(
                          top: 180,
                          left: 2,
                          right: 2,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        hint: new Text(
                                            "Choose your verification methode"),
                                        value: _selected,
                                        onChanged: (String newValue) {
                                          if (newValue
                                              .contains("Identity card"))
                                            setState(() {
                                              _selected = newValue;
                                              identityCard = true;
                                              passport = false;
                                            });
                                          else {
                                            setState(() {
                                              _selected = newValue;
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
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing: 1,
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
                        ),
                        Positioned(
                          bottom: 50,
                          left: 10,
                          right: 10,
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
                                      valid = true;
                                      agentInt = false;
                                    });
                                  }),
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
