import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  Future<Map<String, dynamic>> checkShipping(UserAddress address) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var response = await Api.calculateShipping(address.zipcode);
      if (response['success']) {
        var price = response['response']['sedex']['Valor']
            .replaceAll(RegExp("[^0-9]+"), '');
        var delivery = response['response']['sedex']['PrazoEntrega'];
        context.read<CartModel>().setShippingPrice = int.parse(price);
        context.read<CartModel>().selectedShipping = address.id;
        context.read<CartModel>().setShippingCalcError = false;
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        return response;
      } else {
        context.read<CartModel>().setShippingCalcError = true;
        setState(() {
          _isLoading = false;
        });
        _onFail('Erro ao calcular o frete, tente novamente mais tarde.');
        return null;
      }
    } catch (err) {
      debugPrint('Erro ao calcular frete: $err');
      setState(() {
        _isLoading = false;
      });
      _onFail('Erro ao calcular o frete, tente novamente mais tarde.');
      context.read<CartModel>().setShippingCalcError = true;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  Navigator.pushNamed(context, '/settings/address/editor'),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: context.watch<UserModel>().userData.address.length,
                itemBuilder: (context, index) {
                  var item = context.watch<UserModel>().userData;
                  String street = '${item.address[index].street}';
                  String number = item.address[index].streetNumber != null
                      ? ', ${item.address[index].streetNumber}'
                      : '';
                  String complement = item.address[index].complement != null
                      ? ', ${item.address[index].complement}'
                      : '';
                  return GestureDetector(
                    onTap: () {
                      checkShipping(item.address[index]);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.address[index].name),
                                context.watch<CartModel>().selectedShipping ==
                                        item.address[index].id
                                    ? Icon(Icons.check, color: kPrimaryColor)
                                    : Container(),
                              ],
                            ),
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
