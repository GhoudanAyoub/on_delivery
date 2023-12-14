import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/indicators.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/home/SetUpProfile/ChooseSide.dart';
import 'package:on_delivery/services/auth_service.dart';
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
  String? email;
  String? password;
  String? conform_password;
  bool remember = false;
  AuthService authService = AuthService();
  final List<String?> errors = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  late  User _user;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  bool isSignIn = false;
  String? name = '', image;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
        submitted = false;
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 60),
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
                      child: circularProgress(context),
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
                try {
                  if (_formKey.currentState!.validate()) {
                    submitted = true;
                    bool success = await authService.createUser(
                      email: _emailContoller.text,
                      password: _passwordController.text,
                    );
                    if (success) {
                      Navigator.pushNamed(context, ChooseSide.routeName);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Congratulation Your Account Created')));
                    }
                  }
                } catch (e) {
                  print(e);
                  showInSnackBar(
                      '${authService.handleFirebaseAuthError(e.toString())}');
                }
              }),
        ],
      ),
    );
  }

  void showInSnackBar(String? value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value??"")));
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
                    child: TextButton(
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
      submitAction: (){},
    );
  }

  buildEmailFormField() {
    return TextFormBuilder(
      controller: _emailContoller,
      hintText: "Email",
      suffix: false,
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateEmail,
      submitAction: (){},
    );
  }

  buildConformPassFormField() {
    return TextFormBuilder(
      suffix: true,
      controller: _passwordController2,
      hintText: "Re-type Password",
      textInputAction: TextInputAction.next,
      onSaved: (newValue) => conform_password = newValue,
      submitAction: (){},
      validateFunction: Validations.validatePassword,
    );
  }
}
