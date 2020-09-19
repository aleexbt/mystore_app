import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/models/product_model.dart';
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
  List<ProductVariants> variants = [];
  String selectedSize;
  String selectedColor;
  int selectedQtd = 0;
  int totalAvailable = 0;
  Future _getProduct;
  bool networkError = false;
  int networkStatusCode;

  Map<String, int> sortedSize = {
    'PP': 0,
    'P': 1,
    'M': 2,
    'G': 3,
    'GG': 4,
    'XG': 5,
  };

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
      setVariants();
      return network.response;
    }
  }

  void setVariants() {
    for (var i = 0; i < product.variants.length; i++) {
      setState(() {
        variants.add(
          ProductVariants(
            size: product.variants[i].size,
            color: product.variants[i].color,
            qtd: product.variants[i].qtd,
          ),
        );
      });
    }

    variants.sort((a, b) => sortedSize[a.size] - sortedSize[b.size]);
    ProductVariants selected =
        variants.firstWhere((item) => item.qtd > 0, orElse: null);

    if (selected != null) {
      selectedSize = selected.size;
      selectedColor = selected.color;
      selectedQtd = 1;
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
    bool isLoading = false;
    Set<String> sizeSet = Set<String>();
    variants.sort((a, b) => sortedSize[a.size] - sortedSize[b.size]);
    List<ProductVariants> sizesList =
        variants.where((item) => sizeSet.add(item.size)).toList();
    Iterable<ProductVariants> colorList =
        variants.where((item) => item.size == selectedSize).length > 0
            ? variants.where((item) => item.size == selectedSize)
            : variants;

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
                            //ProductOptions(product, setModalState),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: sizesList.length > 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tamanho',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(height: 5.0),
                                          Row(
                                            children: sizesList.map(
                                              (s) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setModalState(() {
                                                      setState(() {
                                                        selectedSize = s.size;
                                                        selectedColor = null;
                                                        selectedQtd = 1;
                                                      });
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Container(
                                                      height: 40.0,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: s.size ==
                                                                  selectedSize
                                                              ? kPrimaryColor
                                                              : Colors
                                                                  .grey[400],
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          s.size.toUpperCase(),
                                                          style: TextStyle(
                                                            color: s.size ==
                                                                    selectedSize
                                                                ? kPrimaryColor
                                                                : Colors
                                                                    .grey[400],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                          SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: colorList.length > 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cor',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(height: 5.0),
                                          Row(
                                            children: colorList.map(
                                              (c) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setModalState(() {
                                                      setState(() {
                                                        selectedColor = c.color;
                                                        totalAvailable = c.qtd;
                                                      });
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Container(
                                                      height: 40.0,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: c.color ==
                                                                  selectedColor
                                                              ? kPrimaryColor
                                                              : Colors
                                                                  .grey[400],
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(
                                                          10.0,
                                                        ),
                                                        child: Text(
                                                          c.color.toUpperCase(),
                                                          style: TextStyle(
                                                            color: c.color ==
                                                                    selectedColor
                                                                ? kPrimaryColor
                                                                : Colors
                                                                    .grey[400],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                          SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                //SizedBox(height: 10.0),
                                Text(
                                  'Quantidade',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
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
                                            color: Colors.grey[400],
                                          ),
                                          onPressed: () {
                                            if (selectedQtd >= 2) {
                                              setModalState(() {
                                                setState(() {
                                                  selectedQtd--;
                                                });
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      Text(selectedQtd.toString()),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: kPrimaryColor,
                                        ),
                                        onPressed: () {
                                          setModalState(() {
                                            setState(() {
                                              selectedQtd++;
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                        onPressed: selectedSize != null &&
                                selectedColor != null &&
                                context.watch<UserModel>().isLoggedIn
                            ? () {
                                CartProduct cartProduct = CartProduct(
                                  productId: product.id,
                                  title: product.title,
                                  catId: product.category.id,
                                  size: selectedSize,
                                  price: product.price,
                                  image: product.images[0],
                                  qtd: selectedQtd,
                                );
                                context
                                    .read<CartModel>()
                                    .addCartItem(cartProduct);
                                Navigator.pop(context);
                                _successDialog();
                              }
                            : null,
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text('ADICIONAR AO CARRINHO'),
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
