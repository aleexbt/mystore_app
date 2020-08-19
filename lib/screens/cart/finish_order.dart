import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';

class FinishOrder extends StatelessWidget {
  final args;

  FinishOrder(this.args);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido realizado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.teal,
              size: 80.0,
            ),
            Text(
              'Pedido realizado com sucesso!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              'Código do pedido: ${args['orderId']}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 50.0,
              child: RaisedButton(
                color: kPrimaryColor,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/app', (route) => false,
                      arguments: 2);
                },
                child: Text('Ir para meus pedidos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
