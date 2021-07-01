import 'package:flutter/material.dart';
import 'package:on_delivery/utils/SizeConfig.dart';

import 'sign_up_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: SizeConfig.screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SignUpForm(),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
