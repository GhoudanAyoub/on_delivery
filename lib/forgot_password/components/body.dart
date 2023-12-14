import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/form_error.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailContoller = TextEditingController();
  List<String?> errors = [];
  String? email;
  var submitted = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: 10),
          FormError(errors: errors),
          SizedBox(height: 20),
          RaisedGradientButton(
              child: submitted
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "Reset",
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
                if (_formKey.currentState!.validate()) {
                  firebaseAuth.sendPasswordResetEmail(
                      email: _emailContoller.text);
                  Fluttertoast.showToast(
                      msg:
                          "A password reset link has been sent to ${_emailContoller.text}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }),
        ],
      ),
    );
  }

  buildEmailFormField() {
    return TextFormBuilder(
      controller: _emailContoller,
      suffix: false,
      hintText: "Email",
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validateEmail,
      submitAction: (){},
    );
  }
}
