import 'package:flutter/material.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:provider/provider.dart';

class PaymentCard extends StatefulWidget {
  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  String _selectedCard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: ExpansionTile(
        leading: Icon(Icons.credit_card),
        title: Text(
          'Cartão de Crédito',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        children: Provider.of<UserModel>(context).userData.cards.length == 0
            ? <Widget>[
                Text('Você não possui nenhum cartão cadastrado.'),
                SizedBox(height: 10.0),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Settings/CreditCard');
                  },
                  child: Text('Adicionar cartão'),
                ),
                SizedBox(height: 10.0),
              ]
            : <Widget>[
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 16.0),
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<UserModel>(context).userData.cards.length,
                  itemBuilder: (context, index) {
                    var card = Provider.of<UserModel>(context).userData.cards;
                    return ListTile(
                      leading: Radio(
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: card[index].id,
                          groupValue: _selectedCard,
                          onChanged: (value) {
                            Provider.of<CartModel>(context, listen: false)
                                .selectedCard = value;
                            setState(() {
                              _selectedCard = value;
                            });
                          }),
                      title: Text(card[index].name),
                      subtitle: Text('Cartão final ' +
                          '${card[index].number.substring(card[index].number.length - 4)}'),
                    );
                  },
                ),

                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     initialValue: '',
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       hintText: 'Digite seu CEP',
                //     ),
                //     onFieldSubmitted: (text) async {},
                //   ),
                // ),
              ],
      ),
    );
  }
}
