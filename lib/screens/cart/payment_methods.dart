import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PaymentMethods extends StatelessWidget {
  final data;
  //final _changeController = MaskedTextController(mask: '00,00');
  final _changeController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  MaskTextInputFormatter changeFormatter =
      MaskTextInputFormatter(mask: '###,##', filter: {"#": RegExp(r'[0-9]')});
  final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  PaymentMethods({this.data});
  @override
  Widget build(BuildContext context) {
    //_changeController.text = '0,00';
    return Scaffold(
      appBar: AppBar(
        title: Text('Formas de pagamento'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pague pelo app',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.grey[600]),
              ),
              Consumer<UserModel>(
                builder: (context, data, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.userData.cards.length,
                    itemBuilder: (context, index) {
                      var cards = data.userData.cards;
                      return Column(
                        children: [
                          Divider(),
                          GestureDetector(
                            onTap: () {
                              CartModel cartModel = Provider.of<CartModel>(
                                  context,
                                  listen: false);
                              cartModel.onlinePayment = true;
                              cartModel.paymentMethod = 1;
                              cartModel.paymentChange = 0;
                              cartModel.selectedCard = cards[index].id;
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/credit_card_icons/${data.userData.cards[index].brand.toLowerCase()}.svg',
                                        semanticsLabel:
                                            data.userData.cards[index].brand,
                                        width: 18.0,
                                        height: 18.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(cards[index].name.toUpperCase() +
                                          ' **** ' +
                                          '${cards[index].number.substring(cards[index].number.length - 4)}'),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: kPrimaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/settings/credit_card'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cartão de Crédito'),
                      Icon(
                        Icons.add,
                        color: kPrimaryColor,
                        size: 28.0,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 14.0),
              Text(
                'Pague na entrega',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  CartModel cartModel =
                      Provider.of<CartModel>(context, listen: false);
                  cartModel.onlinePayment = false;
                  cartModel.paymentMethod = 1;
                  cartModel.paymentChange = 0;
                  cartModel.selectedCard = null;
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cartão de Crédito'),
                      FaIcon(
                        FontAwesomeIcons.creditCard,
                        color: kPrimaryColor,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () => _cashChangeBottomSheet(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dinheiro'),
                      FaIcon(
                        FontAwesomeIcons.moneyBill,
                        color: kPrimaryColor,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void _cashChangeBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text(
                        'Dinheiro',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('Você vai precisar de troco?',
                        style: TextStyle(
                          color: Colors.grey[500],
                        )),
                    SizedBox(height: 26.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width / 3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onPressed: () {
                              CartModel cartModel = Provider.of<CartModel>(
                                  context,
                                  listen: false);
                              cartModel.onlinePayment = false;
                              cartModel.paymentMethod = 2;
                              cartModel.isChangeNeeded = false;
                              cartModel.paymentChange = 0;
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            color: kPrimaryColor,
                            textColor: Colors.white,
                            child: Text('Não'),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width / 3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _setCashChangeBottomSheet(context);
                            },
                            color: kPrimaryColor,
                            textColor: Colors.white,
                            child: Text('Sim'),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          );
        });
  }

  void _setCashChangeBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Text(
                      'Troco para quanto?',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'O valor do seu pedido é ${currency.format(data['data'] / 100)}',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Digite o valor que vai pagar em dinheiro para que possamos te enviar o troco.',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Text(
                          'R\$',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      IntrinsicWidth(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: TextField(
                            controller: _changeController,
                            keyboardType: TextInputType.number,
                            maxLength: 7,
                            maxLengthEnforced: true,
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.all(5.0),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    const BorderSide(style: BorderStyle.none),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(style: BorderStyle.none),
                              ),
                              //fillColor: Colors.green
                            ),
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26.0),
                  SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: () {
                        setChage(context);
                      },
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      child: Text('Confirmar'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void setChage(context) {
    int total = data['data'];
    int change =
        int.parse(_changeController.text.replaceAll(RegExp("[^0-9]+"), ''));
    if (change > total) {
      CartModel cartModel = Provider.of<CartModel>(context, listen: false);
      cartModel.onlinePayment = false;
      cartModel.paymentMethod = 2;
      cartModel.isChangeNeeded = true;
      cartModel.paymentChange = change;
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      //showAlert(context);
      _colorfullAlert(context);
    }
  }

  void showAlert(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text('Troco inválido'),
          content: Text(
              'Você deve pedir troco para um valor maior que ${currency.format(data['data'] / 100)}.'),
          actions: <Widget>[
            // define os botões na base do dialogo
            FlatButton(
              child: Text(
                "FECHAR",
                style: TextStyle(
                  color: kPrimaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _colorfullAlert(context) {
    EdgeAlert.show(
      context,
      title: 'Troco inválido',
      description:
          'Você deve pedir troco para um valor maior que ${currency.format(data['data'] / 100)}.',
      gravity: EdgeAlert.TOP,
      backgroundColor: Colors.grey[800],
      duration: 4,
    );
  }
}
