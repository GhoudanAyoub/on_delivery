import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:on_delivery/services/payment.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Cards extends StatefulWidget {
  static String routeName = "/cards";
  final String amount;

  const Cards({Key key, this.amount}) : super(key: key);
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
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
    var response = await StripeServices.choseExistingCard(
        card: card, currency: "MAD", amount: widget.amount);
    print('response message : ${response.message}');
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
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            CreditCard card = cards[index];
            return InkWell(
              onTap: () {
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
        ),
      ),
    );
  }
}
