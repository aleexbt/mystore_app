import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';

class Address extends StatelessWidget {
  void _showDialog(UserAddress address, BuildContext context) {
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
                  removeAddress(address, context);
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
                  removeAddress(address, context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

  void removeAddress(UserAddress address, BuildContext context) async {
    Provider.of<UserModel>(context, listen: false).removeAddress(address);
    Provider.of<CartModel>(context, listen: false).addressClear();
    await Api.removeAddress(
        Provider.of<UserModel>(context, listen: false).token, address.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus endereços'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: 28.0,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, '/settings/address_editor'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:
                  Provider.of<UserModel>(context).userData.address.length,
              itemBuilder: (context, index) {
                var item = Provider.of<UserModel>(context).userData;
                String street = '${item.address[index].street}';
                String number = item.address[index].streetNumber != null
                    ? ', ${item.address[index].streetNumber}'
                    : '';
                String complement = item.address[index].complement != null
                    ? ', ${item.address[index].complement}'
                    : '';
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/settings/address_editor',
                      arguments: item.address[index],
                    );
                  },
                  onLongPress: () {
                    _showDialog(item.address[index], context);
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
          ),
        ),
      ),
    );
  }
}
