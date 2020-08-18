import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/components/cart_price.dart';
import 'package:mystore/components/discount_card.dart';
import 'package:mystore/components/ship_card.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/tiles/cart_tile.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartModel = Provider.of<CartModel>(context);
    final bool selectedShipping =
        cartModel.selectedShipping != null && cartModel.selectedShipping != '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu carrinho'),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              '${cartModel.productCount} ${cartModel.productCount == 1 ? "ITEM" : "ITEMS"}',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<CartModel>(context).apiLoading,
        child: Consumer<CartModel>(
          builder: (context, data, child) {
            if (data.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!Provider.of<UserModel>(context).isLoggedIn) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Seu carrinho está vazio.'),
                    SizedBox(height: 16.0),
                    SizedBox(
                      height: 50.0,
                      child: RaisedButton(
                        color: primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, '/auth/login');
                        },
                        child: Text('Entre para adicionar items'),
                      ),
                    ),
                  ],
                ),
              );
            } else if (data.productCount == 0) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        size: 130.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Parece que você ainda não adicionou nenhum item ao seu carrinho.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView(
                children: <Widget>[
                  Column(
                    children: data.products.map((product) {
                      return CartTile(product);
                    }).toList(),
                  ),
                  DiscountCard(),
                  ShipCard(),
                  CartPrice(products: data.products),
                  SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 45.0,
                      child: RaisedButton(
                        onPressed: selectedShipping
                            ? () {
                                Navigator.pushNamed(context, '/cart/checkout');
                              }
                            : null,
                        color: Color.fromARGB(255, 211, 110, 130),
                        textColor: Colors.white,
                        child: Text(selectedShipping
                            ? 'CONTINUAR'
                            : 'Selecione um endereço'),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
