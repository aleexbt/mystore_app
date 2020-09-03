import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/components/cart_price.dart';
import 'package:mystore/components/discount_card.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/tiles/cart_tile.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (context.watch<CartModel>().shippingCalcError &&
        !context.watch<CartModel>().apiLoading) {
      _onFail('Erro ao calcular o frete, tente novamente mais tarde.');
    }
    final cartModel = Provider.of<CartModel>(context);
    final bool selectedShipping =
        cartModel.selectedShipping != null && cartModel.selectedShipping != '';
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, size: 40.0),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('MEU CARRINHO'),
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
                        color: kPrimaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          //Navigator.pushNamed(context, '/auth/login');
                          NavKey.pageController.animateToPage(
                            4,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear,
                          );
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
                  // ShipCard(),
                  selectAddress(context),
                  CartPrice(products: data.products),
                  SizedBox(height: 10.0),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 55.0,
        child: FlatButton(
          disabledColor: kPrimaryColor.withOpacity(0.5),
          disabledTextColor: Colors.grey[200],
          shape: ContinuousRectangleBorder(),
          onPressed:
              selectedShipping && !context.watch<CartModel>().shippingCalcError
                  ? () {
                      Navigator.pushNamed(context, '/cart/checkout');
                    }
                  : null,
          color: Color.fromARGB(255, 211, 110, 130),
          textColor: Colors.white,
          child: Text(
              selectedShipping && !context.watch<CartModel>().shippingCalcError
                  ? 'CONTINUAR'
                  : 'SELECIONE UM ENDEREÇO'),
        ),
      ),
    );
  }

  GestureDetector selectAddress(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, '/cart/select_address');
      },
      child: Container(
        //padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[300],
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              // spreadRadius: 1,
              blurRadius: 0,
              offset: Offset(0.0, 0.5), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 18.0, 10.0, 18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, right: 30.0),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Endereço de entrega',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Escolher',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFail(String msg) async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
    await Future.delayed(Duration(seconds: 2));
  }
}
