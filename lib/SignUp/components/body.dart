import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:on_delivery/components/indicators.dart';
import 'package:on_delivery/home/SetUpProfile/ChooseSide.dart';
import 'package:on_delivery/services/auth_service.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';

import 'sign_up_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      height: SizeConfig.screenHeight - 110,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/pg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 20),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SignUpForm(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
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
                        width: 100,
                        height: 1,
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.23),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  isSignIn != false
                      ? Center(child: circularProgress(context))
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
                                await AuthService.addUsers(
                                    firebaseAuth.currentUser);
                                setState(() {
                                  isSignIn = false;
                                });
                                Navigator.pushNamed(
                                    context, ChooseSide.routeName);
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
                              await signInWithGoogle(context)
                                  .whenComplete(() async {
                                await AuthService.addUsers(
                                    firebaseAuth.currentUser);
                                setState(() {
                                  isSignIn = false;
                                });
                                Navigator.pushNamed(
                                    context, ChooseSide.routeName);
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
            SizedBox(height: 10),
          ],
        ),
      ),
    ));
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
