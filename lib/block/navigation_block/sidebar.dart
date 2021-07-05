import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_delivery/SetUpProfile/ChooseSide.dart';
import 'package:on_delivery/SignIn/sign_in_screen.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/components/text_form_builder.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

import 'menu_item.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);
  UserModel user1;
  TextEditingController ribController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          right: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          left: isSideBarOpenedAsync.data ? 0 : screenWidth - 40,
          child: Row(
            children: <Widget>[
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 20,
                      height: 80,
                      color: Colors.white,
                      alignment: Alignment.centerRight,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 40, top: 100),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/pg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: ListView(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          MenuItem(
                            title: "Home",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.HomePageClickedEvent);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MenuItem(
                            title: "Orders",
                            onTap: () {
                              onIconPressed();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                            stream: usersRef
                                .doc(firebaseAuth.currentUser.uid)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                user1 =
                                    UserModel.fromJson(snapshot.data.data());
                                if (user1.type == "Agent") {
                                  return Column(
                                    children: [
                                      MenuItem(
                                        title: "Plans",
                                        onTap: () {
                                          onIconPressed();
                                          BlocProvider.of<NavigationBloc>(
                                                  context)
                                              .add(NavigationEvents
                                                  .PlansPageClickedEvent);
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MenuItem(
                                        title: "Bank account ID",
                                        onTap: () {
                                          bankAccountID(context);
                                          onIconPressed();
                                        },
                                      ),
                                    ],
                                  );
                                }
                                return Container(
                                  height: 0,
                                );
                              }
                              return Container(
                                height: 0,
                              );
                            },
                          ),
                          StreamBuilder(
                            stream: usersRef
                                .doc(firebaseAuth.currentUser.uid)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                user1 =
                                    UserModel.fromJson(snapshot.data.data());
                                if (user1.type == "Client") {
                                  return Column(
                                    children: [
                                      MenuItem(
                                        title: "Favorite agents",
                                        onTap: () {
                                          onIconPressed();
                                        },
                                      ),
                                    ],
                                  );
                                }
                                return Container(
                                  height: 0,
                                );
                              }
                              return Container(
                                height: 0,
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MenuItem(
                            title: "Conditions & rules",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(
                                  NavigationEvents
                                      .ConditionRulesPageClickedEvent);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MenuItem(
                            title: "Contact us",
                            onTap: () {
                              onIconPressed();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MenuItem(
                            title: "Settings",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(
                                  NavigationEvents.ProfilePageClickedEvent);
                            },
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                        stream: usersRef
                            .doc(firebaseAuth.currentUser.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            user1 = UserModel.fromJson(snapshot.data.data());
                            if (user1.type == "Agent") {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: RaisedGradientButton(
                                    child: Text(
                                      'Switch to costumer',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    border: true,
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.white,
                                        Colors.white
                                      ],
                                    ),
                                    width: SizeConfig.screenWidth - 150,
                                    onPressed: () async {
                                      FirebaseService().switchCurrentUserType(
                                          firebaseAuth.currentUser, "Client");
                                      onIconPressed();
                                    }),
                              );
                            }
                            return Container(
                              height: 0,
                            );
                          }
                          return Container(
                            height: 0,
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: usersRef
                            .doc(firebaseAuth.currentUser.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            user1 = UserModel.fromJson(snapshot.data.data());
                            if (user1.type == "Client" &&
                                int.parse(user1.percentage) != 91) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: RaisedGradientButton(
                                    child: Text(
                                      'Become an Agent',
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
                                      /* FirebaseService().switchCurrentUserType(
                                          firebaseAuth.currentUser, "Agent");*/
                                      onIconPressed();
                                      //todo : add route to setup Page info data Section
                                      Navigator.pushNamed(
                                          context, ChooseSide.routeName);
                                    }),
                              );
                            } else if (user1.type == "Client" &&
                                int.parse(user1.percentage) == 91)
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: RaisedGradientButton(
                                    child: Text(
                                      'Switch to Agent',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    border: true,
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.white,
                                        Colors.white
                                      ],
                                    ),
                                    width: SizeConfig.screenWidth - 150,
                                    onPressed: () async {
                                      FirebaseService().switchCurrentUserType(
                                          firebaseAuth.currentUser, "Agent");
                                      onIconPressed();
                                    }),
                              );
                            return Container(
                              height: 0,
                            );
                          }
                          return Container(
                            height: 0,
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RaisedGradientButton(
                            child: Text(
                              'Sign out',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color.fromRGBO(255, 182, 40, 1),
                                Color.fromRGBO(238, 71, 0, 1)
                              ],
                            ),
                            width: SizeConfig.screenWidth - 150,
                            onPressed: () async {
                              logOut(context);
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  logOut(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 40, right: 40, bottom: 40, top: 40),
                width: 150,
                child: Center(
                  child: Text(
                    'Are you sure, you want to Sign out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 40, right: 40, bottom: 10, top: 20),
                width: 150,
                child: RaisedGradientButton(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[Colors.white, Colors.white],
                    ),
                    width: SizeConfig.screenWidth - 150,
                    onPressed: () async {
                      Navigator.pop(context);
                      FirebaseService().signOut();
                      Navigator.pushNamed(context, SignInScreen.routeName);
                    }),
              ),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40, bottom: 10),
                width: 150,
                child: RaisedGradientButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                      Navigator.pop(context);
                    }),
              ),
            ],
          );
        });
  }

  bankAccountID(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 40),
                width: 150,
                child: Center(
                  child: Text(
                    'There are the bank account information of agent name',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      fontFamily: "Poppins",
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: usersRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    user1 = UserModel.fromJson(snapshot.data.data());
                    ribController.text = user1.RIB;
                    bankNameController.text = user1.bankName;
                    return Column(
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
                    );
                  }
                  return Container(
                    height: 0,
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              RaisedGradientButton(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  border: true,
                  gradient: LinearGradient(
                    colors: <Color>[Colors.white, Colors.white],
                  ),
                  width: SizeConfig.screenWidth - 150,
                  onPressed: () async {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(10, 16, 0, 8);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
