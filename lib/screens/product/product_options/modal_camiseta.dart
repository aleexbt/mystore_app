import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:mystore/models/product_model.dart';
import 'package:provider/provider.dart';

class ModalCamiseta extends StatefulWidget {
  final Product productData;
  final Function successCallback;
  ModalCamiseta(this.productData, this.successCallback);

  @override
  _ModalCamisetaState createState() => _ModalCamisetaState();
}

class _ModalCamisetaState extends State<ModalCamiseta> {
  List<ProductVariants> variants = [];
  String selectedSize;
  String selectedColor;
  int selectedQtd = 0;
  int totalAvailable = 0;

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
    setVariants();
  }

  void setVariants() {
    Product product = widget.productData;
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

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        bool isLoading = false;
        Set<String> sizeSet = Set<String>();
        variants.sort((a, b) => sortedSize[a.size] - sortedSize[b.size]);
        List<ProductVariants> sizesList =
            variants.where((item) => sizeSet.add(item.size)).toList();
        Iterable<ProductVariants> colorList =
            variants.where((item) => item.size == selectedSize).length > 0
                ? variants.where((item) => item.size == selectedSize)
                : variants;
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
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Container(
                                                  height: 40.0,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: s.size ==
                                                              selectedSize
                                                          ? kPrimaryColor
                                                          : Colors.grey[400],
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      s.size.toUpperCase(),
                                                      style: TextStyle(
                                                        color: s.size ==
                                                                selectedSize
                                                            ? kPrimaryColor
                                                            : Colors.grey[400],
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
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Container(
                                                  height: 40.0,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: c.color ==
                                                              selectedColor
                                                          ? kPrimaryColor
                                                          : Colors.grey[400],
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                      10.0,
                                                    ),
                                                    child: Text(
                                                      c.color.toUpperCase(),
                                                      style: TextStyle(
                                                        color: c.color ==
                                                                selectedColor
                                                            ? kPrimaryColor
                                                            : Colors.grey[400],
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
                            Product product = widget.productData;
                            CartProduct cartProduct = CartProduct(
                              productId: product.id,
                              title: product.title,
                              catId: product.category.id,
                              size: selectedSize,
                              price: product.price,
                              image: product.images[0],
                              qtd: selectedQtd,
                            );
                            context.read<CartModel>().addCartItem(cartProduct);
                            Navigator.pop(context);
                            // _successDialog();
                            widget.successCallback();
                          }
                        : null,
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
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
  }
}
