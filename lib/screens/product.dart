import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/components/product_options.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mystore/models/product_model.dart' as p;
import 'package:awesome_dialog/awesome_dialog.dart';

class Product extends StatefulWidget {
  final pid;
  final p.Product product;
  Product({this.pid, this.product});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  p.Product product;
  String size;
  int qtd = 1;
  Future _getProduct;
  bool networkError = false;
  int networkStatusCode;

  @override
  void initState() {
    super.initState();
    if (widget.product == null) {
      _getProduct = getProduct();
    }
  }

  Future getProduct() async {
    NetworkHandler network = await Api.productById(widget.pid);
    if (network.error) {
      setState(() {
        networkError = true;
        networkStatusCode = network.statusCode;
      });
    } else {
      setState(() {
        product = p.Product.fromJson(network.response);
      });
      return network.response;
    }
  }

  Future retry() async {
    setState(() {
      networkError = false;
      networkStatusCode = null;
    });
    _getProduct = getProduct();
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('DETALHES'),
      ),
      body: FutureBuilder(
        future: _getProduct,
        builder: (context, snapshot) {
          if (networkError) {
            return NetworkError(retry, statusCode: networkStatusCode);
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.1,
                child: Carousel(
                  images: product.images.map((url) {
                    return buildCachedNImage(
                      image: url,
                      iconSize: 80.0,
                      iconColor: Colors.black54,
                    );
                  }).toList(),
                  dotSize: 5.0,
                  dotSpacing: 15.0,
                  dotBgColor: Colors.transparent,
                  dotColor: Color.fromARGB(100, 211, 110, 130),
                  overlayShadow: true,
                  dotIncreasedColor: Color.fromARGB(255, 211, 110, 130),
                  autoplay: false,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                            fontSize: 17.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 15.0),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '${currency.format(product.price / 100)}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descrição',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ]),
                  ),
                ],
              )
            ],
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 55.0,
        child: _buyButton(context),
      ),
    );
  }

  _buyButton(BuildContext context) {
    if (product?.id == null) {
      return Container();
    } else if (product?.available == null || !product.available) {
      return FlatButton(
        shape: ContinuousRectangleBorder(),
        color: kPrimaryColor,
        disabledColor: kPrimaryColor.withOpacity(0.5),
        disabledTextColor: Colors.grey[600],
        textColor: Colors.white,
        onPressed: null,
        child: Text(
          'PRODUTO INDISPONÍVEL',
        ),
      );
      // } else if (context.watch<CartModel>().products.isNotEmpty &&
      //     context.watch<CartModel>().products.firstWhere(
      //             (element) => element.productId == product.id,
      //             orElse: null) !=
      //         null) {
      //   return FlatButton(
      //     shape: ContinuousRectangleBorder(),
      //     color: kPrimaryColor,
      //     disabledColor: kPrimaryColor.withOpacity(0.5),
      //     disabledTextColor: Colors.grey[600],
      //     textColor: Colors.white,
      //     onPressed: null,
      //     child: Text(
      //       'PRODUTO INDISPONÍVEL 0',
      //     ),
      //   );
    } else {
      return FlatButton(
        shape: ContinuousRectangleBorder(),
        color: kPrimaryColor,
        disabledColor: kPrimaryColor.withOpacity(0.5),
        disabledTextColor: Colors.grey[600],
        textColor: Colors.white,
        onPressed: () => _selectProduct(context),
        child: Text(
          'SELECIONAR',
        ),
      );
    }
  }

  void _selectProduct(context) {
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
            return Wrap(children: [
              SafeArea(
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Container(
                              width: 40.0,
                              height: 4.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Opções do produto',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            ProductOptions(product),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       product.variants[0].name,
                            //       style: TextStyle(fontSize: 16.0),
                            //     ),
                            //     SizedBox(height: 5.0),
                            //     Row(
                            //       children: product.variants[0].options
                            //           .where((element) => element.qtd >= 1)
                            //           .map((s) {
                            //         return GestureDetector(
                            //           onTap: () {
                            //             setModalState(() {
                            //               size = s.value;
                            //               qtd = 1;
                            //             });
                            //             setState(() {
                            //               size = s.value;
                            //               qtd = 1;
                            //             });
                            //           },
                            //           child: Padding(
                            //             padding:
                            //                 const EdgeInsets.only(right: 8.0),
                            //             child: Container(
                            //               width: 50.0,
                            //               height: 40.0,
                            //               alignment: Alignment.center,
                            //               decoration: BoxDecoration(
                            //                 border: Border.all(
                            //                   color: s.value == size
                            //                       ? kPrimaryColor
                            //                       : Colors.grey[400],
                            //                   width: 1.0,
                            //                 ),
                            //                 borderRadius:
                            //                     BorderRadius.circular(4.0),
                            //               ),
                            //               child: Text(
                            //                 s.value,
                            //                 style: TextStyle(
                            //                   color: s.value == size
                            //                       ? kPrimaryColor
                            //                       : Colors.grey[400],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         );
                            //       }).toList(),
                            //     ),
                            //     SizedBox(height: 10.0),
                            //     Text(
                            //       'Quantidade',
                            //       style: TextStyle(
                            //         fontSize: 16.0,
                            //       ),
                            //     ),
                            //     SizedBox(height: 5.0),
                            //     Container(
                            //       width: 120.0,
                            //       height: 45.0,
                            //       alignment: Alignment.center,
                            //       decoration: BoxDecoration(
                            //         border: Border.all(
                            //           color: Colors.grey[400],
                            //           width: 1.0,
                            //         ),
                            //         borderRadius: BorderRadius.circular(4.0),
                            //       ),
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           SizedBox(
                            //             child: IconButton(
                            //               icon: Icon(
                            //                 Icons.remove,
                            //                 color: qtd == 1
                            //                     ? Colors.grey[400]
                            //                     : kPrimaryColor,
                            //               ),
                            //               onPressed: () {
                            //                 if (qtd >= 2) {
                            //                   setModalState(() {
                            //                     setState(() {
                            //                       qtd--;
                            //                     });
                            //                   });
                            //                 }
                            //               },
                            //             ),
                            //           ),
                            //           Text(qtd.toString()),
                            //           IconButton(
                            //             icon: Icon(
                            //               Icons.add,
                            //               color: kPrimaryColor,
                            //             ),
                            //             onPressed: () {
                            //               // int stock = product.variants
                            //               //     .firstWhere(
                            //               //         (element) =>
                            //               //             element['size'] == size,
                            //               //         orElse: () => 0)['qtd'];
                            //               // if (qtd < stock) {
                            //               //   setModalState(() {
                            //               //     setState(() {
                            //               //       qtd++;
                            //               //     });
                            //               //   });
                            //               // }
                            //             },
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55.0,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: ContinuousRectangleBorder(),
                        color: kPrimaryColor,
                        disabledColor: kPrimaryColor.withOpacity(0.5),
                        disabledTextColor: Colors.grey[600],
                        textColor: Colors.white,
                        onPressed: size != null &&
                                context.watch<UserModel>().isLoggedIn
                            ? () {
                                CartProduct cartProduct = CartProduct(
                                  productId: product.id,
                                  title: product.title,
                                  catId: product.category.id,
                                  size: size,
                                  price: product.price,
                                  image: product.images[0],
                                  qtd: qtd,
                                );
                                context
                                    .read<CartModel>()
                                    .addCartItem(cartProduct);
                                Navigator.pop(context);
                                _successDialog();
                              }
                            : null,
                        child: Text(
                          'ADICIONAR AO CARRINHO',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          },
        );
      },
    );
  }

  void _successDialog() {
    AwesomeDialog(
      context: _scaffoldKey.currentContext,
      animType: AnimType.BOTTOMSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      title: 'Tudo certo',
      useRootNavigator: true,
      padding: EdgeInsets.only(left: 10, right: 10),
      desc: 'Este produto foi adicionado ao seu carrinho com sucesso.',
      btnOkText: 'OK',
      btnOkOnPress: () {},
      onDissmissCallback: () {
        Navigator.pop(context);
      },
      btnOkIcon: Icons.check_circle,
      btnOkColor: kPrimaryColor,
    )..show();
  }
}
