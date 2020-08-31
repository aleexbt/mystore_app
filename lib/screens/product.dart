import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/datas/cart_product.dart';
// import 'package:mystore/datas/product_data.dart';
import 'package:mystore/helpers/navigation_helper.dart';
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
  p.Product product;
  String size;
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(product?.title ?? ''),
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
                aspectRatio: 0.9,
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
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                    ),
                    Text(
                      '${currency.format(product.price / 100)}',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Tamanho',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 34.0,
                      child: GridView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.5,
                        ),
                        children: product.sizes.map((s) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                size = s;
                              });
                            },
                            child: Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                                border: Border.all(
                                  color: s == size
                                      ? Colors.blue
                                      : Colors.grey[500],
                                  width: 3.0,
                                ),
                              ),
                              child: Text(s),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Consumer<UserModel>(
                      builder: (context, data, child) {
                        if (!data.isLoggedIn) {
                          return SizedBox(
                            height: 45.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              color: kPrimaryColor,
                              textColor: Colors.white,
                              onPressed: size != null
                                  ? () {
                                      // Navigator.pushNamed(
                                      //   context,
                                      //   '/auth/login',
                                      //   arguments: 1,
                                      // );
                                      NavKey.pageController.animateToPage(
                                        4,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.linear,
                                      );
                                    }
                                  : null,
                              child: Text(
                                'Adicionar ao carrinho',
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 45.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: kPrimaryColor,
                            textColor: Colors.white,
                            onPressed: size != null
                                ? () {
                                    CartProduct cartProduct = CartProduct(
                                      productId: product.id,
                                      title: product.title,
                                      catId: product.category.id,
                                      size: size,
                                      price: product.price,
                                      image: product.images[0],
                                      qtd: 1,
                                    );
                                    //CartController.to.addCartItem(cartProduct);
                                    Provider.of<CartModel>(context,
                                            listen: false)
                                        .addCartItem(cartProduct);
                                    // Navigator.pushReplacementNamed(
                                    //     context, '/cart');
                                    // NavKey.pageController.animateToPage(
                                    //   3,
                                    //   duration: Duration(milliseconds: 200),
                                    //   curve: Curves.linear,
                                    // );

                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.BOTTOMSLIDE,
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.SUCCES,
                                      title: 'Tudo certo',
                                      useRootNavigator: true,
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      desc:
                                          'Este produto foi adicionado ao seu carrinho com sucesso.',
                                      btnOkText: 'OK',
                                      btnOkOnPress: () {
                                        //Navigator.pop(context);
                                      },
                                      btnOkIcon: Icons.check_circle,
                                    )..show();

                                    //Navigator.pop(context);

                                    //NavKey.pageController.jumpToPage(3);
                                  }
                                : null,
                            child: Text(
                              'Adicionar ao carrinho',
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
