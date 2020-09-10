import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartTile extends StatefulWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _editCartProduct(context),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: buildCachedNImage(
              image: widget.cartProduct.image,
              iconSize: 30.0,
              iconColor: Colors.black54,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 270.0,
                            child: Text(
                              widget.cartProduct.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '${currency.format(widget.cartProduct.price / 100)}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            'Tamanho: ${widget.cartProduct.size}',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            'Quantidade: ${widget.cartProduct.qtd}',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editCartProduct(context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Wrap(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              width: 120.0,
                              child: buildCachedNImage(
                                image: widget.cartProduct.image,
                                iconSize: 30.0,
                                iconColor: Colors.black54,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 250.0,
                                              child: Text(
                                                widget.cartProduct.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              '${currency.format(widget.cartProduct.price / 100)}',
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 6.0),
                                            Text(
                                              'Tamanho: ${widget.cartProduct.size}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 120.0,
                                height: 45.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[400],
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: widget.cartProduct.qtd == 1
                                              ? Colors.grey[400]
                                              : kPrimaryColor,
                                        ),
                                        onPressed: () {
                                          if (widget.cartProduct.qtd >= 2) {
                                            setModalState(() {
                                              context
                                                  .read<CartModel>()
                                                  .decProduct(
                                                      widget.cartProduct);
                                              // setState(() {
                                              //   widget.cartProduct.qtd--;
                                              // });
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Text(widget.cartProduct.qtd.toString()),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: kPrimaryColor,
                                      ),
                                      onPressed: () {
                                        setModalState(() {
                                          context
                                              .read<CartModel>()
                                              .incProduct(widget.cartProduct);
                                          // setState(() {
                                          //   widget.cartProduct.qtd++;
                                          // });
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  context
                                      .read<CartModel>()
                                      .removeCartItem(widget.cartProduct);
                                  Navigator.pop(context);
                                  if (context.read<CartModel>().productCount ==
                                      0) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline, size: 20.0),
                                    Text('REMOVER'),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
