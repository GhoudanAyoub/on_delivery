import 'package:flutter/material.dart';
import 'package:on_delivery/SignIn/sign_in_screen.dart';
import 'package:on_delivery/utils/firebase.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    new Future.delayed(Duration(seconds: 3), () {
      if (firebaseAuth.currentUser != null) {
      }
      /* Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));*/
      else
        Navigator.pushNamed(context, SignInScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/pg.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
