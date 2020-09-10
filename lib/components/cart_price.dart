import 'package:flutter/material.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartPrice extends StatelessWidget {
  final List<CartProduct> products;

  CartPrice({this.products});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(left: 8, top: 4, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[300],
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Consumer<CartModel>(
        builder: (context, data, child) {
          int prices = data.getProductsPrice();
          int discount = data.getDiscount();
          int ship = data.shippingPrice;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Text(
              //   'Resumo do Pedido',
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Subtotal'),
                  Text('${currency.format(prices / 100)}'),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Desconto'),
                  Text(
                      '${discount > 0 ? "-" : ""}${currency.format(discount / 100)}'),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Entrega'),
                  Text('${currency.format(ship / 100)}'),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total'),
                  Text(
                    '${currency.format((prices + ship - discount) / 100)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
