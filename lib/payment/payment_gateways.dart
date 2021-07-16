import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/components/indicators.dart';
import 'package:on_delivery/payment/PaypalPayment.dart';
import 'package:on_delivery/payment/cars.dart';
import 'package:on_delivery/payment/success.dart';
import 'package:on_delivery/services/payment.dart';

class PaymentGateways extends StatefulWidget {
  static String routeName = "/PaymentGateways";
  final String amount;

  const PaymentGateways({Key key, this.amount}) : super(key: key);
  @override
  _PaymentGatewaysState createState() => _PaymentGatewaysState();
}

class _PaymentGatewaysState extends State<PaymentGateways> {
  bool visible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeServices.init();
  }

  payNow(String price) async {
    await StripeServices.payNowHandler(amount: price, currency: 'MAD')
        .then((value) {
      if (value.success == true)
        Navigator.pushNamed(context, Success.routeName);
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${value.message}"),
          duration: Duration(seconds: 3),
        ));
        setState(() {
          visible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        title: Center(
          child: Text("Payment Gateways",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 60),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(23),
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        Icon icon;
                        Text text;
                        switch (index) {
                          case 0:
                            break;
                          case 1:
                            icon = Icon(Icons.add_circle, color: Colors.green);
                            text = Text('ADD CARD');
                            break;
                          case 2:
                            icon = Icon(Icons.credit_card, color: Colors.green);
                            text = Text('CHOOSE CARD');
                            break;
                        }

                        return InkWell(
                          onTap: () {
                            onItemPress(context,
                                index); //called to select the function to call depending on the method chosen
                          },
                          child: index == 0
                              ? Card(
                                  elevation: 8.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.orangeAccent.withOpacity(0.9),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/paypal.png",
                                        ),
                                      ],
                                    ),
                                  ))
                              : Card(
                                  elevation: 8.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white.withOpacity(0.9),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Colors.white,
                                          Colors.white
                                        ],
                                      ),
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        icon,
                                        SizedBox(
                                          width: 5,
                                        ),
                                        text
                                      ],
                                    ),
                                  )),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                            color: Color.fromRGBO(160, 163, 189, 0.9),
                            thickness: 1,
                          ),
                      itemCount: 3),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: 'This Section is still under development\n',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal)),
                      TextSpan(
                          text:
                              'This will be available only for people outside morocco\n',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.normal)),
                      TextSpan(
                          text: ' No real founds are taken!',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.red)),
                    ], style: TextStyle(letterSpacing: 1)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Visibility(
                    child: circularProgress(context),
                    visible: visible,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  width: 135,
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
              ),
            ],
          )),
    ));
  }

  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PaypalPayment(
                'LIVE365 ${widget.amount.toString()} Coin',
                widget.amount.toString()),
          ),
        );
        break;
      case 1:
        payNow(widget.amount);
        setState(() {
          visible = true;
        });
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Cards(
                    amount: widget.amount,
                  )),
        ); //calls the list of cards screen
        break;
    }
  }
}
