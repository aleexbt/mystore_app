import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/models/user_model.dart';
import 'package:provider/provider.dart';

class Payment extends StatelessWidget {
  void _showDialog(UserCard card, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover cartão?'),
          content: Text('Você não poderá desfazer esta ação.'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Confirmar",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                removeCard(card, context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void removeCard(UserCard card, BuildContext context) async {
    Provider.of<UserModel>(context, listen: false).removeCard(card);
    Provider.of<CartModel>(context, listen: false).paymentClear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formas de pagamento'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: 28.0,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, '/settings/payment/editor'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<UserModel>(context).userData.cards.length,
                  itemBuilder: (context, index) {
                    var cards = Provider.of<UserModel>(context).userData.cards;
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/settings/payment/editor',
                          arguments: cards[index],
                        );
                      },
                      onLongPress: () {
                        _showDialog(cards[index], context);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'Cartão final ${cards[index].number.substring(cards[index].number.length - 4)}'),
                              Divider(),
                              Text(
                                cards[index].name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '**** **** **** ${cards[index].number.substring(cards[index].number.length - 4)}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Os dados do seu cartão ficam armazenados somente em seu dispositivo de forma criptografada.',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
