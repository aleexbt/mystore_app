import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/components/cart_price.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/screens/cart/select_address.dart';
import 'package:mystore/services/api.dart';
import 'package:mystore/tiles/cart_tile.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _discountController = TextEditingController();

  Future<String> checkCupon() async {
    var res = await Api.checkCoupon(_discountController.text);
    if (res.data['valid']) {
      FocusScope.of(context).unfocus();
      context
          .read<CartModel>()
          .setCoupon(_discountController.text, res.data['percentage']);
      return res.data['msg'];
    } else {
      return res.data['msg'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final bool selectedShipping =
        cartModel.selectedShipping != null && cartModel.selectedShipping != '';
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, size: 40.0),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('MEU CARRINHO (${cartModel.productCount})'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black),
            onPressed: () {
              context.read<CartModel>().clearCart();
              Navigator.pop(context);
            },
          ),
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
                  // DiscountCard(),

                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _insertCoupon(),
                    child: Container(
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
                            offset:
                                Offset(0.0, 0.5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 18.0, 10.0, 18.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Tem um cupom de desconto?',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.add, color: kPrimaryColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  // ShipCard(),
                  selectAddress2(context),
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

  selectAddress2(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, data, child) {
        UserAddress address = data.selectedShipping != null
            ? context.watch<UserModel>().userData.address.firstWhere(
                (element) => element.id == data.selectedShipping,
                orElse: null)
            : null;
        String streetName = address?.street ?? '';
        String streetNumber =
            address?.streetNumber != null ? ', ${address.streetNumber}' : '';
        String complement =
            address?.complement != null && address?.complement != ''
                ? ', ${address.complement}'
                : '';
        return OpenContainer(
          transitionType: ContainerTransitionType.fade,
          openBuilder: (context, openContainer) => SelectAddress(),
          closedColor: Colors.grey[100],
          closedElevation: 0.0,
          closedShape: ContinuousRectangleBorder(),
          openShape: ContinuousRectangleBorder(),
          closedBuilder: (context, openContainer) {
            return Container(
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
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Text('Endereço de Entrega'),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        data.selectedShipping == null
                            ? Text(
                                'Nenhum endereço selecionado',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              )
                            : Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      streetName + streetNumber + complement,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(address?.neighborhood ?? ''),
                                    SizedBox(height: 5),
                                    Text(
                                      '${address?.city} - ${address?.state}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      address?.zipcode != null
                                          ? UserFunctions.cepFormatter(
                                              address?.zipcode,
                                            )
                                          : '',
                                    ),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Escolher',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  GestureDetector selectAddress(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //Navigator.pushNamed(context, '/cart/select_address');
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

  void _insertCoupon() {
    String msg = '';
    bool isLoading = false;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Wrap(children: [
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      width: 40.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Cupom de desconto',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.0),
                              TextFormField(
                                controller: _discountController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 0.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryColor, width: 0.0),
                                  ),
                                  hintText: 'Insira o código do cupom aqui',
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(msg),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55.0,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: ContinuousRectangleBorder(),
                        color: kPrimaryColor,
                        disabledColor: kPrimaryColor.withOpacity(0.5),
                        disabledTextColor: Colors.grey[600],
                        textColor: Colors.white,
                        onPressed: isLoading
                            ? null
                            : () async {
                                setModalState(() {
                                  isLoading = true;
                                });
                                String response = await checkCupon();
                                setModalState(() {
                                  msg = response;
                                  isLoading = false;
                                });
                              },
                        child: !isLoading
                            ? Text(
                                'APLICAR',
                              )
                            : CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          },
        );
      },
    );
  }
}
