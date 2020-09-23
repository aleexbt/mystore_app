import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartTile extends StatefulWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  bool isCheckingStock = false;

  Future<bool> checkStock(CartProduct product) async {
    Map<String, dynamic> data = {
      'size': product.size,
      'qtd': product.qtd + 1,
    };
    NetworkHandler network = await Api.checkStock(product.productId, data);
    if (network.error) {
      return false;
    } else {
      return network.response['available'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 90,
              width: 90,
              child: buildCachedNImage(
                image: widget.cartProduct.image,
                iconSize: 30.0,
                iconColor: Colors.black54,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartProduct.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      'Tamanho: ${widget.cartProduct.size}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if (widget.cartProduct.qtd >= 2) {
                              context
                                  .read<CartModel>()
                                  .decProduct(widget.cartProduct);
                            }
                          },
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: widget.cartProduct.qtd == 1
                                ? Colors.grey[400]
                                : kPrimaryColor,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.cartProduct.qtd.toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            setState(() {
                              isCheckingStock = true;
                            });
                            bool stock = await checkStock(widget.cartProduct);
                            if (stock) {
                              context
                                  .read<CartModel>()
                                  .incProduct(widget.cartProduct);
                            }
                            setState(() {
                              isCheckingStock = false;
                            });
                          },
                          child: isCheckingStock
                              ? SizedBox(
                                  width: 21,
                                  height: 21,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5),
                                )
                              : Icon(
                                  Icons.add_circle_outline,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 85.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        context
                            .read<CartModel>()
                            .removeCartItem(widget.cartProduct);
                        if (context.read<CartModel>().productCount == 0) {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(Icons.close)),
                  Text(
                    '${currency.format(widget.cartProduct.price / 100)}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
