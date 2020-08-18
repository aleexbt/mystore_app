import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTile extends StatelessWidget {
  final order;
  OrderTile(this.order);
  @override
  Widget build(BuildContext context) {
    int status = order['orderStatus'];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Código do Pedido: #${order['_id']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(_buildProductsText(order)),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildCircle('1', 'Preparando', status, 1),
                Container(height: 1.0, width: 40.0, color: Colors.grey[500]),
                _buildCircle('2', 'Transporte', status, 2),
                Container(height: 1.0, width: 40.0, color: Colors.grey[500]),
                _buildCircle('3', 'Entrega', status, 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildProductsText(snapshot) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    String text = 'Descrição:\n';
    for (var p in snapshot['products']) {
      text +=
          '${p['qtd']} x ${p['title']} (${currency.format(p['price'] / 100)})\n';
    }
    text += 'Total: ${currency.format(snapshot['total'] / 100)}';
    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backgroundColor;
    Widget child;

    if (status < thisStatus) {
      backgroundColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      backgroundColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backgroundColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backgroundColor,
          child: child,
        ),
        Text(subtitle),
      ],
    );
  }
}
