import 'package:flutter/material.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';

class ShipCard extends StatefulWidget {
  @override
  _ShipCardState createState() => _ShipCardState();
}

class _ShipCardState extends State<ShipCard> {
  String _selectedAddress;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var currentAddress =
        Provider.of<CartModel>(context, listen: false).selectedShipping;
    _selectedAddress = currentAddress ?? null;
  }

  Future<Map<String, dynamic>> checkShipping() async {
    UserAddress address = Provider.of<UserModel>(context, listen: false)
        .userData
        .address
        .firstWhere((element) => element.id == _selectedAddress, orElse: null);
    if (address != null) {
      Provider.of<CartModel>(context, listen: false).setApiLoading = true;
      var response = await Api.calculateShipping(address.zipcode);
      if (response['success']) {
        var price = response['response']['sedex']['Valor']
            .replaceAll(RegExp("[^0-9]+"), '');
        // var delivery = response['response']['sedex']['PrazoEntrega'];
        Provider.of<CartModel>(context, listen: false).setShippingPrice =
            int.parse(price);
        Provider.of<CartModel>(context, listen: false).setApiLoading = false;
        return response;
      } else {
        Provider.of<CartModel>(context, listen: false).setApiLoading = false;
        return null;
      }
    } else {
      Provider.of<CartModel>(context, listen: false).setApiLoading = false;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        leading: Icon(Icons.location_on),
        title: Text(
          'Entrega',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        children: Provider.of<UserModel>(context, listen: false)
                    .userData
                    .address
                    .length ==
                0
            ? <Widget>[
                Text('Você não possui nenhum endereço cadastrado.'),
                SizedBox(height: 10.0),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings/address');
                  },
                  child: Text('Adicionar endereço'),
                ),
                SizedBox(height: 10.0),
              ]
            : <Widget>[
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 16.0),
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<UserModel>(context).userData.address.length,
                  itemBuilder: (context, index) {
                    var address =
                        Provider.of<UserModel>(context).userData.address;
                    var item = Provider.of<UserModel>(context).userData;
                    String street = '${address[index].street}';
                    String number = item.address[index].streetNumber != null
                        ? ', ${address[index].streetNumber}'
                        : '';
                    String complement = item.address[index].complement != null
                        ? ', ${address[index].complement}'
                        : '';
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Provider.of<CartModel>(context, listen: false)
                                .selectedShipping = item.address[index].id;
                            setState(() {
                              _selectedAddress = item.address[index].id;
                            });
                            checkShipping();
                          },
                          leading: Radio(
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: item.address[index].id,
                              groupValue: _selectedAddress,
                              onChanged: (value) {
                                Provider.of<CartModel>(context, listen: false)
                                    .selectedShipping = value;
                                setState(() {
                                  _selectedAddress = value;
                                });
                                checkShipping();
                              }),
                          title: Text(
                            street + number + complement,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                          subtitle: Text(
                              '${item.address[index].city} - ${item.address[index].state}'),
                        ),
                      ],
                    );
                    // return ListTile(
                    //   leading: Radio(
                    //       visualDensity: VisualDensity.compact,
                    //       materialTapTargetSize:
                    //           MaterialTapTargetSize.shrinkWrap,
                    //       value: address[index].id,
                    //       groupValue: _selectedAddress,
                    //       onChanged: (value) {
                    //         Provider.of<CartModel>(context, listen: false)
                    //             .selectedShipping = value;
                    //         setState(() {
                    //           _selectedAddress = value;
                    //         });
                    //       }),
                    //   title: Text(address[index].name),
                    //   subtitle: Text(street + number + complement),
                    // );
                  },
                ),

                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     initialValue: '',
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       hintText: 'Digite seu CEP',
                //     ),
                //     onFieldSubmitted: (text) async {},
                //   ),
                // ),
              ],
      ),
    );
  }
}
