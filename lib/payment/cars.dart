import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:on_delivery/components/indicators.dart';
import 'package:on_delivery/payment/success.dart';
import 'package:on_delivery/services/payment.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Cards extends StatefulWidget {
  static String routeName = "/cards";
  final String amount;

  const Cards({Key? key, this.amount}) : super(key: key);
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  bool visible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeServices.init();
  }

  List cards = [
    CreditCard(
        currency: "MAD",
        name: "TheOne",
        cvc: "424",
        expMonth: 04,
        expYear: 2024,
        brand: 'visa',
        funding: "credit",
        last4: '4242',
        country: 'US',
        number: "4242424242424242"),
    CreditCard(
      currency: "MAD",
      name: "Karim",
      number: "5555555555554444",
      cvc: "424",
      expMonth: 02,
      expYear: 2025,
      brand: 'visa',
      funding: "credit",
      last4: '4444',
      country: 'US',
    )
  ];

  payNow(CreditCard card) async {
    await StripeServices.choseExistingCard(
            card: card, currency: "MAD", amount: widget.amount)
        .then((value) {
      if (value.success == true)
        Navigator.pushNamed(context, Success.routeName);
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${value.message}"),
          duration: Duration(seconds: 1),
        ));
        setState(() {
          visible = false;
        });
      }
    });
  }

//Page widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(23),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  CreditCard card = cards[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        visible = true;
                      });
                      payNow(card);
                    },
                    child: CreditCardWidget(
                      cardNumber: "${card.number}",
                      expiryDate: "${card.expMonth}/${card.expYear}",
                      cardHolderName: "${card.name}",
                      cvvCode: "${card.cvc}",
                      showBackView: false,
                    ),
                  );
                },
              )),
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
    );
  }
}
