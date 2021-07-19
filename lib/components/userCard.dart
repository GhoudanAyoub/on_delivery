import 'package:flutter/material.dart';
import 'package:on_delivery/home/agent_details.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';
import 'package:on_delivery/utils/firebase.dart';

class UserCard extends StatefulWidget {
  final UserModel userModel;

  const UserCard({Key key, this.userModel}) : super(key: key);
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  int myDocs = 0;
  int doneDocs = 0;
  double rate = null;

  getMyOrders() {
    orderRef.snapshots().listen((element) {
      element.docChanges.forEach((element) {
        Orders order = Orders.fromJson(element.doc.data());
        if (order.userId.contains(widget.userModel.id) ||
            order.agentId.contains(widget.userModel.id)) {
          setState(() {
            myDocs++;
          });
          if (order.status.toLowerCase().contains("delivered"))
            setState(() {
              doneDocs++;
            });
        }
      });
    });
  }

  getReviews2() {
    double i = 0;
    int j = 1;
    rateRef.snapshots().listen((event) {
      event.docChanges.forEach((element) {
        if (element.doc.data()["agentId"].contains(widget.userModel.id)) {
          j++;
          i += element.doc.data()["rate"];
        }
      });
    });
    setState(() {
      rate = (i / j);
    });
  }

  @override
  void initState() {
    getMyOrders();
    getReviews2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.only(
                  left: getProportionateScreenHeight(10),
                  right: getProportionateScreenHeight(10)),
              height: getProportionateScreenHeight(150),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    width: 1, color: Color.fromRGBO(231, 231, 231, 1)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.userModel.photoUrl !=
                                    null
                                ? widget.userModel.photoUrl
                                : "https://images.unsplash.com/photo-1571741140674-8949ca7df2a7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60"),
                            fit: BoxFit.cover,
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
                        height: getProportionateScreenHeight(60),
                        width: getProportionateScreenHeight(60),
                      ),
                      Container(
                        width: getProportionateScreenWidth(230),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        "${widget.userModel.firstName} ${widget.userModel.lastname.toUpperCase()}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    widget.userModel.verified == "true"
                                        ? Image.asset(
                                            "assets/images/ver_agent.png")
                                        : SizedBox(height: 0)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset('assets/images/agent rate.png'),
                                    Text(rate != null ? "$rate" : "NR",
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text("${widget.userModel.city}",
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                )),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: getProportionateScreenWidth(150),
                                  child: Text(
                                      "${widget.userModel.activities.toLowerCase()}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      )),
                                ),
                                Text(
                                    "${widget.userModel.price != "" ? widget.userModel.price : '??'}/${widget.userModel.unity.toLowerCase()}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(231, 231, 231, 1)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 30,
                        width: getProportionateScreenWidth(150),
                        margin: EdgeInsets.only(right: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Orders delivered",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                )),
                            Text("$doneDocs/$myDocs",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: Color.fromRGBO(238, 71, 0, 1)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 30,
                        width: getProportionateScreenWidth(90),
                        margin: EdgeInsets.only(left: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Details",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  foreground: Paint()
                                    ..shader = orangeLinearGradient,
                                )),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AgentsDetails(
                      id: widget.userModel.id,
                    )),
          );
        },
      ),
    );
  }
}
