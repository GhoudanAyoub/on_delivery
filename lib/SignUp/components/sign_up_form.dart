import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:on_delivery/SetUpProfile/ChooseSide.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/services/auth_service.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  var submitted = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();
  String email;
  String password;
  String conform_password;
  bool remember = false;
  AuthService authService = AuthService();
  final List<String> errors = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  bool isSignIn = false;
  String name = '', image;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
        submitted = false;
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 80),
            buildEmailFormField(),
            SizedBox(height: 20),
            buildPasswordFormField(),
            SizedBox(height: 20),
            buildConformPassFormField(),
            SizedBox(height: 30),
            RaisedGradientButton(
                child: submitted
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Sign up',
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
                onPressed: () async {
                  Navigator.pushNamed(context, ChooseSide.routeName);
                  /*

                  try {
                    if (_formKey.currentState.validate()) {
                      submitted = true;
                      bool success = await authService.createUser(
                          name: _namentoller.text,
                          email: _emailContoller.text,
                          password: _passwordController.text,
                          country: _countryContoller.text,
                          phone: _phone.text);
                      print(success);
                      if (success) {
                        /*
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home()));*/
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Congratulation Your Account Created')));
                      }
                    }
                  } catch (e) {
                    print(e);
                    showInSnackBar(
                        '${authService.handleFirebaseAuthError(e.toString())}');
                  }*/
                }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 1,
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.23),
                  ),
                ),
                Divider(
                  indent: 5,
                  endIndent: 5,
                ),
                Text(
                  "OR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color.fromRGBO(0, 0, 0, 0.23),
                  ),
                ),
                Divider(
                  indent: 5,
                  endIndent: 5,
                ),
                SizedBox(
                  width: 150,
                  height: 1,
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.23),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            isSignIn != false
                ? Center(child: CircularProgressIndicator())
                : SizedBox(height: 1),
            SizedBox(height: 10),
            isSignIn == false
                ? Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        loginWithFacebook(context).whenComplete(() async {
                          var u = await FirebaseService.addUsers(
                              firebaseAuth.currentUser);
                          setState(() {
                            isSignIn = false;
                          });
                          /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen()));*/
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/fb.svg",
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Continue with facebook",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(15, 94, 249, 1)),
                            )
                          ],
                        ),
                      ),
                    ))
                : SizedBox(height: 1),
            isSignIn == false
                ? Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () async {
                        await signInWithGoogle(context).whenComplete(() async {
                          var u = await FirebaseService.addUsers(
                              firebaseAuth.currentUser);
                          setState(() {
                            isSignIn = false;
                          });
                          /* Navigator.pushNamed(
                                  context, HomeScreen.routeName);*/
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/google-icon.svg",
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Continue with Google",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(15, 94, 249, 1)),
                            )
                          ],
                        ),
                      ),
                    ))
                : SizedBox(height: 1),
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  void emailExists() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height: 190,
              child: Column(
                children: [
                  Container(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            'This Email is on Another Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            "You can log into the account associated with that email.",
                            style: TextStyle(color: Colors.white60),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0,
                    height: 0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/HomeScreen'));
                      },
                      child: Text(
                        'Log in to Existing Account',
                        style: TextStyle(color: Colors.lightBlue[400]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  buildPasswordFormField() {
    return TextFormBuilder(
      controller: _passwordController,
      suffix: true,
      hintText: "Create a Password",
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validatePassword,
    );
  }

  buildEmailFormField() {
    return TextFormBuilder(
      controller: _emailContoller,
      hintText: "Email",
      suffix: false,
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateEmail,
    );
  }

  buildConformPassFormField() {
    return TextFormBuilder(
      suffix: true,
      controller: _passwordController2,
      hintText: "Re-type Password",
      textInputAction: TextInputAction.next,
      onSaved: (newValue) => conform_password = newValue,
    );
  }

  Future<void> signInWithGoogle(context) async {
    setState(() {
      isSignIn = true;
    });
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Checking Your Account..")));
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("please Wait..")));
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    UserCredential userdata =
        await _firebaseAuth.signInWithCredential(credential).catchError((e) {
      print("Error===>" + e.toString());
    });
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("please Wait..")));
  }

  Future loginWithFacebook(context) async {
    setState(() {
      isSignIn = true;
    });
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=first_name,picture&access_token=${accessToken.token}');
        final profile = jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          name = profile['first_name'];
          image = profile['picture']['data']['url'];
        });

        AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        await _auth.signInWithCredential(credential).catchError((e) {
          print(e.toString());
        });
        print('''
         Logged in!
         
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }
}
