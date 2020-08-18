import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DiscountCard extends StatefulWidget {
  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  final _discountController = TextEditingController();
  Timer _debounce;
  int _debouncetime = 800;
  FocusNode _focus = FocusNode();
  String _settedCoupon;

  void couponChanged() async {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () async {
      if (_discountController.text != "" &&
          _focus.hasFocus &&
          _settedCoupon != _discountController.text) {
        Provider.of<CartModel>(context, listen: false).setApiLoading = true;
        var res = await Api.checkCoupon(_discountController.text);
        if (res.data['valid']) {
          FocusScope.of(context).unfocus();
          Provider.of<CartModel>(context, listen: false)
              .setCoupon(_discountController.text, res.data['percentage']);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              content: Text(res.data['msg']),
              backgroundColor: Colors.teal,
            ),
          );
          Provider.of<CartModel>(context, listen: false).setApiLoading = false;
          setState(() {
            _settedCoupon = _discountController.text;
          });
        } else {
          Provider.of<CartModel>(context, listen: false).setApiLoading = false;
          setState(() {
            _settedCoupon = _discountController.text;
          });
          Provider.of<CartModel>(context, listen: false).setCoupon(null, 0);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              content: Text(res.data['msg']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  @override
  void initState() {
    _discountController.text =
        Provider.of<CartModel>(context, listen: false).couponCode ?? null;
    //_discountController.addListener(couponChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        leading: Icon(Icons.card_giftcard),
        //trailing: Icon(Icons.add),
        title: Text(
          'Cupom de desconto',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _discountController,
              textCapitalization: TextCapitalization.characters,
              focusNode: _focus,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu cupom',
              ),
              onFieldSubmitted: (text) async {
                var res = await Api.checkCoupon(text);
                if (res.data['valid']) {
                  Provider.of<CartModel>(context, listen: false)
                      .setCoupon(text, res.data['percentage']);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(res.data['msg']),
                      backgroundColor: Colors.teal,
                    ),
                  );
                } else {
                  Provider.of<CartModel>(context, listen: false)
                      .setCoupon(null, 0);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(res.data['msg']),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
