import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final int tagId;
  CartButton(this.tagId);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: tagId,
      onPressed: () {
        Navigator.pushNamed(context, '/cart');
      },
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    );
  }
}
