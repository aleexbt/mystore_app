import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/screens/product/product_options/select_roupas.dart';
import 'package:mystore/screens/product/show_photo.dart';
import 'package:mystore/services/api.dart';
import 'package:intl/intl.dart';
import 'package:mystore/models/product_model.dart' as p;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';

class Roupas extends StatefulWidget {
  final pid;
  final p.Product product;

  Roupas({this.pid, this.product});

  @override
  _RoupasState createState() => _RoupasState();
}

class _RoupasState extends State<Roupas> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  p.Product product;
  bool isLoadingStockCheck = false;
  bool alreadyInCart = false;
  String selectedSize;
  int selectedAvailableItems;
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

  void setSize(s, qtd) {
    setState(() {
      selectedSize = s;
      selectedAvailableItems = qtd;
    });
    checkAlreadyInCart();
  }

  void checkAlreadyInCart() {
    List<CartProduct> cartProducts = context.read<CartModel>().products;
    if (cartProducts.length > 0 &&
        cartProducts.firstWhere(
                (item) =>
                    item.productId == widget.pid && item.size == selectedSize,
                orElse: () => null) !=
            null) {
      setState(() {
        alreadyInCart = true;
      });
    } else {
      setState(() {
        alreadyInCart = false;
      });
    }
  }

  Future<bool> checkStock() async {
    Map<String, dynamic> data = {
      'size': selectedSize,
      'qtd': 1,
    };
    NetworkHandler network = await Api.checkStock(widget.pid, data);
    if (network.error) {
      return false;
    } else {
      return network.response['available'];
    }
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShowPhoto(product.images, 1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                      onImageTap: (value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ShowPhoto(product.images, value),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      product.title,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectRoupas(product, _successDialog, setSize),
                          Divider(),
                          Text(
                            'Características',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            ),
                          ),
                        ]),
                  ],
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(1.0, 0.0), // shadow direction: bottom right
              )
            ],
          ),
          child: SizedBox(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product?.price != null
                      ? currency.format(product.price / 100)
                      : '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: _buyButton(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buyButton(BuildContext context) {
    if (product?.id == null) {
      return Container();
    } else if (product?.available == null ||
        !product.available ||
        selectedAvailableItems != null && selectedAvailableItems == 0) {
      return SizedBox(
        height: 50.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: kPrimaryColor,
          disabledColor: kPrimaryColor.withOpacity(0.5),
          disabledTextColor: Colors.grey[600],
          textColor: Colors.white,
          onPressed: null,
          child: Text(
            'INDISPONÍVEL',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      );
    } else if (alreadyInCart) {
      return SizedBox(
        height: 50.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: kPrimaryColor,
          disabledColor: Colors.grey[300],
          disabledTextColor: Colors.grey[600],
          textColor: Colors.white,
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PRODUTO ADICIONADO',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.check, size: 20),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 50.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: kPrimaryColor,
          disabledColor: kPrimaryColor.withOpacity(0.5),
          disabledTextColor: Colors.grey[600],
          textColor: Colors.white,
          onPressed: selectedSize != null && !isLoadingStockCheck
              ? () async {
                  setState(() {
                    isLoadingStockCheck = true;
                  });
                  bool stock = await checkStock();
                  if (stock) {
                    CartProduct cartProduct = CartProduct(
                      productId: product.id,
                      title: product.title,
                      catId: product.category.id,
                      size: selectedSize,
                      price: product.price,
                      image: product.images[0],
                      qtd: 1,
                    );
                    context.read<CartModel>().addCartItem(cartProduct);
                    setState(() {
                      alreadyInCart = true;
                    });
                  } else {
                    setState(() {
                      selectedAvailableItems = 0;
                    });
                  }
                  setState(() {
                    isLoadingStockCheck = false;
                  });
                }
              : null,
          child: isLoadingStockCheck
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
              : Text(
                  'ADICIONAR AO CARRINHO',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
        ),
      );
    }
  }

  void _successDialog() {
    AwesomeDialog(
      context: _scaffoldKey.currentContext,
      animType: AnimType.BOTTOMSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      title: 'Tudo certo',
      useRootNavigator: false,
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
