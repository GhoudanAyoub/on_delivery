import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/home/trackingmap.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/utils/FirebaseService.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/utils.dart';
import 'package:provider/provider.dart';

class OrderLayout extends StatefulWidget {
  final Orders order;
  final UserModel user;
  final UserModel me;
  final bool track;
  final bool count;
  final bool show;
  final String Time;

  const OrderLayout(
      {Key key,
      this.order,
      this.user,
      this.track = true,
      this.Time,
      this.count = true,
      this.me,
      this.show = false})
      : super(key: key);
  @override
  _OrderLayoutState createState() => _OrderLayoutState();
}

class _OrderLayoutState extends State<OrderLayout> {
  String startFrom, endAt;
  LocationProvider locationData;
  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context);
    locationData
        .getCurrentCoordinatesName(
            widget.order.startAt.latitude, widget.order.startAt.longitude)
        .then((value) {
      setState(() {
        startFrom = value;
      });
    });
    locationData
        .getCurrentCoordinatesName(
            widget.order.endAt.latitude, widget.order.endAt.longitude)
        .then((value) {
      setState(() {
        endAt = value;
      });
    });
    return Align(
      alignment: Alignment.bottomCenter,
      child: Expanded(
        child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.only(
                  top: 10,
                  left: getProportionateScreenHeight(20),
                  right: getProportionateScreenHeight(10),
                  bottom: 5),
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
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Stack(
                          fit: StackFit.passthrough,
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                widget.user.photoUrl != null
                                    ? widget.user.photoUrl
                                    : FirebaseService.getProfileImage(),
                              ),
                              radius: 30.0,
                            ),
                            Positioned(
                              right: -5,
                              bottom: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                height: 15,
                                width: 15,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.user?.isOnline ?? false
                                          ? Color(0xff00d72f)
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    height: 11,
                                    width: 11,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: getProportionateScreenWidth(230),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                    "${widget.user.firstName} ${widget.user.lastname.toUpperCase()}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                                widget.user.verified == "true"
                                    ? Image.asset("assets/images/ver_agent.png")
                                    : SizedBox(height: 0)
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Text("Activities : ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    )),
                                Text("${widget.user.activities.toLowerCase()}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      )
                    ],
                  ),
                  Divider(
                      thickness: 2, color: Color.fromRGBO(230, 230, 230, 1)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Date : ",
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                      Text(
                          "${DateFormat('yyyy-MM-dd AT kk:mm').format(Utils.toDateTime(widget.order.date))}",
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 120,
                        child: Text("$startFrom",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        CupertinoIcons.arrow_right,
                        color: Colors.green,
                        size: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 120,
                        child: Text("$endAt",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.order.status
                                  .toLowerCase()
                                  .contains("canceled")
                              ? Color.fromRGBO(254, 29, 29, 1).withOpacity(0.2)
                              : widget.order.status
                                      .toLowerCase()
                                      .contains("pending")
                                  ? Color.fromRGBO(195, 199, 24, 1)
                                      .withOpacity(0.2)
                                  : Color.fromRGBO(10, 201, 71, 1)
                                      .withOpacity(0.2),
                          border: Border.all(
                            width: 1,
                            color: widget.order.status
                                    .toLowerCase()
                                    .contains("canceled")
                                ? Color.fromRGBO(254, 29, 29, 1)
                                    .withOpacity(0.2)
                                : widget.order.status
                                        .toLowerCase()
                                        .contains("pending")
                                    ? Color.fromRGBO(195, 199, 24, 1)
                                        .withOpacity(0.2)
                                    : Color.fromRGBO(10, 201, 71, 1)
                                        .withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 30,
                        width: getProportionateScreenWidth(90),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${widget.order.status}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: widget.order.status
                                        .toLowerCase()
                                        .contains("canceled")
                                    ? Color.fromRGBO(254, 29, 29, 1)
                                    : widget.order.status
                                            .toLowerCase()
                                            .contains("pending")
                                        ? Color.fromRGBO(195, 199, 24, 1)
                                        : Color.fromRGBO(10, 201, 71, 1),
                              ),
                            )
                          ],
                        ),
                      ),
                      widget.count
                          ? GestureDetector(
                              onTap: locationNotificationInto,
                              child: Image.asset(
                                'assets/images/delete order.png',
                                height: 50,
                              ),
                            )
                          : Container()
                    ],
                  ),
                  Divider(
                      thickness: 2, color: Color.fromRGBO(230, 230, 230, 1)),
                  SizedBox(
                    height: 5,
                  ),
                  widget.track &&
                          widget.me != null &&
                          !widget.me.type.toLowerCase().contains('agent')
                      ? ExpandChild(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: RaisedGradientButton(
                                    child: Text(
                                      'Track Item',
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromRGBO(82, 238, 79, 1),
                                        Color.fromRGBO(5, 151, 0, 1)
                                      ],
                                    ),
                                    width: getProportionateScreenWidth(200),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TrackingMap(
                                              orders: widget.order,
                                              userModel: widget.user,
                                            ),
                                          ));
                                    }),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        )
                      : Container(),
                  widget.show &&
                          widget.me != null &&
                          widget.me.type.toLowerCase().contains('agent') == true
                      ? ExpandChild(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: RaisedGradientButton(
                                    child: Text(
                                      'Show on the map',
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromRGBO(255, 182, 40, 1),
                                        Color.fromRGBO(238, 71, 0, 1)
                                      ],
                                    ),
                                    width: getProportionateScreenWidth(200),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ShowOnMap(
                                              orders: widget.order,
                                              userModel: widget.user,
                                            ),
                                          ));
                                    }),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            )),
      ),
    );
  }

  locationNotificationInto() {
    return showDialog(
        context: context,
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Do You want to delete this Orders?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          fontFamily: "Poppins",
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  RaisedGradientButton(
                      child: Text(
                        'Yes,',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                      border: false,
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(82, 238, 79, 1),
                          Color.fromRGBO(5, 151, 0, 1)
                        ],
                      ),
                      width: SizeConfig.screenWidth - 150,
                      onPressed: () async {
                        orderRef.doc(widget.order.orderId).delete();
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedGradientButton(
                      child: Text(
                        'No keep it',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          letterSpacing: 1,
                        ),
                      ),
                      border: true,
                      gradient: LinearGradient(
                        colors: <Color>[Colors.white, Colors.white],
                      ),
                      width: SizeConfig.screenWidth - 150,
                      onPressed: () async {
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          );
        });
  }
}
