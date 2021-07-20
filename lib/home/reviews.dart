import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_delivery/components/rate_layout.dart';
import 'package:on_delivery/models/rate.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';

class Review extends StatefulWidget {
  static String routeName = "/Review";
  final String id;

  const Review({Key key, this.id}) : super(key: key);
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  ScrollController scrollController = ScrollController();
  List<DocumentSnapshot> rateList = [];
  bool loading = true;
  bool empty = true;
  @override
  void initState() {
    getReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(5, 151, 0, 1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20)),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              ),
              SizedBox(height: 40),
              empty
                  ? buildReviews()
                  : Expanded(
                      child: Column(
                        children: [
                          Center(
                              child: Lottie.asset(
                                  'assets/lotties/chat_not_ready.json')),
                          Text("No Chat For The Moments",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: getProportionateScreenWidth(120),
                      height: 5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[Colors.grey, Colors.grey],
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
                              offset: Offset(0.0, 1.5),
                              blurRadius: 1.5,
                            ),
                          ]),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          )),
    ));
  }

  buildReviews() {
    if (!loading) {
      if (rateList.isEmpty) {
        return RefreshIndicator(
          child: Container(
            height: 150,
            child: Center(child: Lottie.asset('assets/lotties/not_found.json')),
          ),
          onRefresh: _refreshReviews,
        );
      } else {
        return Expanded(
            child: RefreshIndicator(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
            itemCount: rateList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot doc = rateList[index];
              RateModel rate = RateModel.fromJson(doc.data());
              if (rate.agentId.contains(widget.id))
                return RateLayout(
                  id: widget.id,
                  rateModel: rate,
                );
              return Container();
            },
          ),
          onRefresh: _refreshReviews,
        ));
      }
    } else {
      return Container(
        child: Center(child: Lottie.asset('assets/lotties/comp_loading.json')),
      );
    }
  }

  Future<Null> _refreshReviews() async {
    getReviews();
  }

  getReviews() async {
    QuerySnapshot snap = await rateRef.get();
    List<DocumentSnapshot> doc = snap.docs;
    setState(() {
      rateList = doc;
      loading = false;
    });
  }
}
