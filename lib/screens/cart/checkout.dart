import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class Checkout extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Resumo do pedido'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<CartModel>(context).isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Consumer2<CartModel, UserModel>(
                builder: (context, data, userdata, child) {
              if (data.products.length == 0) {
                return Container();
              }
              UserAddress address = userdata.userData.address
                  .firstWhere((element) => element.id == data.selectedShipping);
              String streetName = address.street ?? '';
              String streetNumber = address.streetNumber != null
                  ? ', ${address.streetNumber}'
                  : '';
              String complement =
                  address.complement != null ? ', ${address.complement}' : '';

              int prices = data.getProductsPrice();
              int discount = data.getDiscount();
              int ship = data.shippingPrice;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: SvgPicture.asset(
                      'assets/shop.svg',
                      semanticsLabel: 'Sacola de Compras',
                      color: kPrimaryColor,
                      width: 150.0,
                    ),
                  ),
                  Text(
                    'CONFIRME SEU PEDIDO',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.0,
                      color: Colors.grey[500],
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.all(17.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.products.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${data.products[index].qtd}x ' +
                                        data.products[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    )),
                                Text(
                                    '${currency.format(data.products[index].price / 100)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    )),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'ENTREGAR EM',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      color: Colors.grey[500],
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          address.name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(streetName + streetNumber + complement),
                        Text(address.neighborhood),
                        Text('${address.city} - ${address.state}'),
                        Text(UserFunctions.cepFormatter(address.zipcode)),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            Text(
                              '${currency.format(prices / 100)}',
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Desconto',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            Text(
                              '${discount > 0 ? "-" : ""}${currency.format(discount / 100)}',
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Entrega',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            Text(
                              '${currency.format(ship / 100)}',
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            Text(
                              '${currency.format((prices + ship - discount) / 100)}',
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'FORMA DE PAGAMENTO',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      color: Colors.grey[500],
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Provider.of<CartModel>(context).paymentMethod == null
                      ? selectPaymentType(context, prices, ship, discount)
                      : selectedPaymentType(context, prices, ship, discount),
                  SizedBox(height: 14.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 45.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed:
                            Provider.of<CartModel>(context).paymentMethod !=
                                    null
                                ? () async {
                                    String resCheckout =
                                        await Provider.of<CartModel>(context,
                                                listen: false)
                                            .finishOrder(context);

                                    if (resCheckout != null) {
                                      _checkoutError2(context, resCheckout);
                                    }
                                  }
                                : null,
                        color: Color.fromARGB(255, 211, 110, 130),
                        textColor: Colors.white,
                        child: Text('FINALIZAR COMPRA'),
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  GestureDetector selectPaymentType(
      BuildContext context, int prices, int ship, int discount) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/cart/payment_methods', arguments: {
        'data': (prices + ship - discount),
      }),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Formas de pagamento'),
                  Text(
                    'Escolher',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  GestureDetector selectedPaymentType(
      BuildContext context, int prices, int ship, int discount) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/cart/payment_methods', arguments: {
        'data': (prices + ship - discount),
      }),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getPaymentTitle(context)),
                      Text(
                        getPaymentSubtitle(context),
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getPaymentFlag(context),
                      SizedBox(width: 12.0),
                      Text(
                        'Trocar',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  String getPaymentTitle(context) {
    if (Provider.of<CartModel>(context).paymentMethod == 2) {
      return 'Dinheiro';
    } else if (Provider.of<CartModel>(context).paymentMethod == 1) {
      return 'Cartão de Crédito';
    } else {
      return 'Outros';
    }
  }

  String getPaymentSubtitle(context) {
    if (Provider.of<CartModel>(context).paymentMethod == 2 &&
        Provider.of<CartModel>(context).isChangeNeeded) {
      return 'Troco para ${currency.format(Provider.of<CartModel>(context).paymentChange / 100)}';
    } else if (Provider.of<CartModel>(context).paymentMethod == 2 &&
        !Provider.of<CartModel>(context).isChangeNeeded) {
      return 'Sem troco';
    } else if (Provider.of<CartModel>(context).paymentMethod == 1 &&
        Provider.of<CartModel>(context).selectedCard != null) {
      UserCard card = Provider.of<UserModel>(context, listen: false)
          .userData
          .cards
          .firstWhere((item) =>
              item.id == Provider.of<CartModel>(context).selectedCard);
      return '${card.name.toUpperCase()} **** ${card.number.substring(card.number.length - 4)}';
    } else {
      return 'Pagamento na entrega';
    }
  }

  getPaymentFlag(context) {
    if (Provider.of<CartModel>(context).paymentMethod == 2) {
      return FaIcon(
        FontAwesomeIcons.moneyBill,
        size: 20.0,
      );
    } else {
      if (Provider.of<CartModel>(context, listen: false).onlinePayment) {
        UserCard card = Provider.of<UserModel>(context, listen: false)
            .userData
            .cards
            .firstWhere((item) =>
                item.id == Provider.of<CartModel>(context).selectedCard);

        return SvgPicture.asset(
          'assets/credit_card_icons/${card.brand.toLowerCase()}.svg',
          semanticsLabel: card.brand,
          width: 18.0,
          height: 18.0,
        );
      } else {
        return FaIcon(
          FontAwesomeIcons.creditCard,
          size: 20.0,
        );
      }
    }
  }

  // void _checkoutError(String msg) async {
  //   _scaffoldKey.currentState.showSnackBar(
  //     SnackBar(
  //       content: Text(msg),
  //       backgroundColor: Colors.red,
  //       duration: Duration(seconds: 6),
  //     ),
  //   );
  //   await Future.delayed(Duration(seconds: 6));
  // }

  void _checkoutError2(context, String msg) {
    EdgeAlert.show(
      context,
      title: 'Pagamento recusado',
      description: msg,
      gravity: EdgeAlert.TOP,
      backgroundColor: Colors.red,
      duration: 5,
    );
  }
}
