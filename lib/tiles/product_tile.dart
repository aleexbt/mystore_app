import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:intl/intl.dart';
import 'package:mystore/models/product_model.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final Product product;
  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed('/home/product', arguments: product.id);
      },
      child: Card(
        child: type == 'grid'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.9,
                    child: buildCachedNImage(
                      image: product.images[0],
                      iconSize: 50.0,
                      iconColor: Colors.black54,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            product.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${currency.format(product.price / 100)}',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 250.0,
                      child: buildCachedNImage(
                        image: product.images[0],
                        iconSize: 50.0,
                        iconColor: Colors.black54,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${currency.format(product.price / 100)}',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
