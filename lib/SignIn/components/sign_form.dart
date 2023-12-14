import 'package:flutter/material.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/form_error.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/helpers/keyboard.dart';
import 'package:on_delivery/home/SetUpProfile/ChooseSide.dart';
import 'package:on_delivery/home/base.dart';
import 'package:on_delivery/services/auth_service.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool remember = false;
  final List<String?> errors = [];

  var submitted = false;
  var buttonText = "Sign In";

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

  buildPasswordFormField() {
    return TextFormBuilder(
      suffix: true,
      controller: _passwordController,
      hintText: "Password",
      textInputAction: TextInputAction.next,
      validateFunction: Validations.validatePassword,
      submitAction: (){},
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

  bool _secureText = true;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildEmailFormField(),
          SizedBox(height: 15),
          buildPasswordFormField(),
          SizedBox(height: 30),
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
                      buttonText,
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
                AuthService auth = AuthService();
                if (_formKey.currentState!.validate()) {
                  submitted = true;
                  KeyboardUtil.hideKeyboard(context);
                  String? success;
                  try {
                    removeError(error: success);
                    success = await auth.loginUser(
                       _emailContoller.text,
                      _passwordController.text,
                    );
                    if (success == firebaseAuth.currentUser.uid) {
                      final data = await usersRef.doc(success).get();
                      if (data.exists) {
                        Navigator.pushNamed(context, Base.routeName);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Welcome Back')));
                      } else {
                        Navigator.pushNamed(context, ChooseSide.routeName);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'You have To Finish uploading your data')));
                      }
                    } else {
                      addError(error: success);
                      submitted = false;
                    }
                  } catch (e) {
                    submitted = false;
                    addError(error: success);
                    showInSnackBar(
                        '${auth.handleFirebaseAuthError(e.toString())}');
                  }
                }
              }),
          FormError(errors: errors),
        ],
      ),
    );
  }

  void showInSnackBar(String? value) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value??"")));
  }
}
