import 'package:flutter/material.dart';
import 'package:on_delivery/Condition & rules/C&R.dart';
import 'package:on_delivery/SetUpProfile/ChooseSide.dart';
import 'package:on_delivery/SetUpProfile/UpdateProfile.dart';
import 'package:on_delivery/SignIn/sign_in_screen.dart';
import 'package:on_delivery/SignUp/sign_up_screen.dart';
import 'package:on_delivery/SplashScreen/splash_screen.dart';
import 'package:on_delivery/home/Home.dart';
import 'package:on_delivery/home/agent_details.dart';
import 'package:on_delivery/home/base.dart';
import 'package:on_delivery/home/orders_screen.dart';
import 'package:on_delivery/home/search_screen.dart';
import 'package:on_delivery/plans/plans_screen.dart';
import 'package:on_delivery/profiles/profile.dart';

import 'firebase.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ChooseSide.routeName: (context) => ChooseSide(),
  UpdateProfiles.routeName: (context) => UpdateProfiles(),
  MapScreen.routeName: (context) => MapScreen(
        user: firebaseAuth.currentUser,
      ),
  MapTripScreen.routeName: (context) => MapTripScreen(
        user: firebaseAuth.currentUser,
      ),
  Home.routeName: (context) => Home(),
  CR.routeName: (context) => CR(),
  Base.routeName: (context) => Base(),
  Profile.routeName: (context) => Profile(),
  Plans.routeName: (context) => Plans(),
  OrderScreen.routeName: (context) => OrderScreen(),
  AgentsDetails.routeName: (context) => AgentsDetails(),
  SearchScreen.routeName: (context) => SearchScreen(),
  AllAgent.routeName: (context) => AllAgent(),
  SearchMapTripScreen.routeName: (context) => SearchMapTripScreen(),
};
