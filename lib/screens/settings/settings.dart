import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/components/text_input.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';
import 'package:cpfcnpj/cpfcnpj.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSavingData = false;

  MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  void _showDialog(UserAddress address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              'Remover endereço?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text('Você não poderá desfazer esta ação.'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Confirmar",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  removeAddress(address);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: Text(
              'Remover endereço?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text('Você não poderá desfazer esta ação.'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Colors.blue,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Confirmar",
                  style: TextStyle(
                    color: Colors.red,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  removeAddress(address);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

  void removeAddress(UserAddress address) async {
    Provider.of<UserModel>(context, listen: false).removeAddress(address);
    Provider.of<CartModel>(context, listen: false).addressClear();
    await Api.removeAddress(
        Provider.of<UserModel>(context, listen: false).token, address.id);
  }

  void updateUser() async {
    setState(() {
      _isSavingData = true;
    });
    String token = Provider.of<UserModel>(context, listen: false).token;
    var userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text.replaceAll(RegExp("[^0-9]+"), ''),
      'cpf': _cpfController.text.replaceAll(RegExp("[^0-9]+"), ''),
    };
    Provider.of<UserModel>(context, listen: false).updateUser(userData);
    var response = await Api.updateUser(userData, token);
    setState(() {
      _isSavingData = false;
    });
    if (response.data['success']) {
      _saveResponse(response.data['msg'], Colors.teal, 4);
    } else {
      _saveResponse(response.data['msg'], Colors.red, 4);
    }
  }

  void _showDialogCard(UserCard card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover cartão?'),
          content: Text('Você não poderá desfazer esta ação.'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Confirmar",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                removeCard(card);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void removeCard(UserCard card) async {
    Provider.of<UserModel>(context, listen: false).removeCard(card);
    Provider.of<CartModel>(context, listen: false).paymentClear();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = Provider.of<UserModel>(context).userData.name;
    _emailController.text = Provider.of<UserModel>(context).userData.email;
    _phoneController.text =
        Provider.of<UserModel>(context).userData.phone ?? null;
    _cpfController.text =
        CPF.format(Provider.of<UserModel>(context).userData.cpf) ?? null;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Configurações'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(MdiIcons.checkBold),
              onPressed: () => updateUser(),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSavingData,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.0),
                          Text('Nome completo'),
                          SizedBox(height: 5.0),
                          TextInput(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            hintText: 'Nome completo',
                          ),
                          SizedBox(height: 10.0),
                          Text('E-mail'),
                          SizedBox(height: 5.0),
                          TextInput(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Endereço de email',
                          ),
                          SizedBox(height: 10.0),
                          Text('Telefone'),
                          SizedBox(height: 5.0),
                          TextInput(
                            isRequired: false,
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            hintText: 'Número de telefone',
                          ),
                          SizedBox(height: 10.0),
                          Text('CPF'),
                          SizedBox(height: 5.0),
                          TextInput(
                            isRequired: false,
                            controller: _cpfController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [cpfFormatter],
                            hintText: 'Número do CPF',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'MEUS ENDEREÇOS',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: Colors.grey[500],
                          letterSpacing: 2.0,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Visibility(
                      visible: Provider.of<UserModel>(context)
                              .userData
                              .address
                              .length ==
                          0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Você ainda não adicionou nenhum endereço.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: Provider.of<UserModel>(context)
                          .userData
                          .address
                          .length,
                      itemBuilder: (context, index) {
                        var item = Provider.of<UserModel>(context).userData;
                        String street = '${item.address[index].street}';
                        String number = item.address[index].streetNumber != null
                            ? ', ${item.address[index].streetNumber}'
                            : '';
                        String complement =
                            item.address[index].complement != null
                                ? ', ${item.address[index].complement}'
                                : '';
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/settings/address',
                              arguments: item.address[index],
                            );
                          },
                          onLongPress: () {
                            _showDialog(item.address[index]);
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item.address[index].name),
                                  Divider(),
                                  Text(
                                    street + number + complement,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(item.address[index].neighborhood),
                                  Text(
                                      '${item.address[index].city} - ${item.address[index].state}'),
                                  Text(UserFunctions.cepFormatter(
                                      item.address[index].zipcode)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/settings/address'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Adicionar novo endereço',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'MEUS CARTÕES',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: Colors.grey[500],
                          letterSpacing: 2.0,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Visibility(
                      visible: Provider.of<UserModel>(context)
                              .userData
                              .cards
                              .length ==
                          0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Você ainda não adicionou nenhum cartão.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          Provider.of<UserModel>(context).userData.cards.length,
                      itemBuilder: (context, index) {
                        var cards =
                            Provider.of<UserModel>(context).userData.cards;
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/settings/credit_card',
                              arguments: cards[index],
                            );
                          },
                          onLongPress: () {
                            _showDialogCard(cards[index]);
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      'Cartão final ${cards[index].number.substring(cards[index].number.length - 4)}'),
                                  Divider(),
                                  Text(
                                    cards[index].name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '**** **** **** ${cards[index].number.substring(cards[index].number.length - 4)}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/settings/credit_card'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Adicionar novo cartão',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () =>
                            Provider.of<UserModel>(context, listen: false)
                                .logOut(context),
                        child: Row(
                          children: [Text('Sair'), Icon(MdiIcons.exitToApp)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveResponse(String text, Color color, int duration) async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        duration: Duration(seconds: duration),
      ),
    );
    await Future.delayed(Duration(seconds: duration));
  }
}
