import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: buildCachedNImage(
              image: cartProduct.image,
              iconSize: 30.0,
              iconColor: Colors.black54,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cartProduct.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    'Tamanho: ${cartProduct.size}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    '${currency.format(cartProduct.price / 100)}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Color.fromARGB(255, 211, 110, 130),
                        onPressed: cartProduct.qtd > 1
                            ? () {
                                //CartController.to.decProduct(cartProduct);
                                Provider.of<CartModel>(context, listen: false)
                                    .decProduct(cartProduct);
                              }
                            : null,
                      ),
                      Text(cartProduct.qtd.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Color.fromARGB(255, 211, 110, 130),
                        onPressed: () {
                          //CartController.to.incProduct(cartProduct);
                          Provider.of<CartModel>(context, listen: false)
                              .incProduct(cartProduct);
                        },
                      ),
                      FlatButton(
                        onPressed: () {
                          //CartController.to.removeCartItem(cartProduct);
                          Provider.of<CartModel>(context, listen: false)
                              .removeCartItem(cartProduct);
                        },
                        child: Text(
                          'Remover',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
