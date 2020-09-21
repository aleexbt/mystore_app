import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/screens/product/product_options/modal_camiseta.dart';
import 'package:mystore/screens/product/show_photo.dart';
import 'package:mystore/services/api.dart';
import 'package:intl/intl.dart';
import 'package:mystore/models/product_model.dart' as p;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'product_options/modal_smartphone.dart';

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

  // Future<bool> checkStock({String cSize, String cColor, int cQtd}) async {
  //   Map<String, dynamic> data = {
  //     'size': cSize ?? size,
  //     'color': cColor ?? color,
  //     'qtd': cQtd ?? qtd,
  //   };
  //   NetworkHandler network = await Api.checkStock(widget.pid, data);
  //   if (network.error) {
  //     debugPrint('network error');
  //     return false;
  //   } else {
  //     debugPrint(network.response['available'].toString());
  //     return network.response['available'];
  //   }
  // }
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
                      print(value);
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
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 55.0,
          child: _buyButton(context),
        ),
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
          if (product.category.code == '00005') {
            return ModalSmartphone(product, _successDialog);
          } else {
            return ModalCamiseta(product, _successDialog);
          }
        });
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
