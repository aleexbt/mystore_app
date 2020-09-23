import 'package:flutter/material.dart';
import 'package:mystore/components/product_box.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/models/product_model.dart';
import 'package:mystore/services/api.dart';

class Category extends StatefulWidget {
  final args;
  Category(this.args);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  Future _getCategoryProducts;
  bool networkError = false;
  int networkStatusCode;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _getCategoryProducts = getCategoryProducts();
  }

  getCategoryProducts() async {
    NetworkHandler network = await Api.productsByCategory(widget.args['catId']);
    if (network.error) {
      setState(() {
        networkError = true;
        networkStatusCode = network.statusCode;
      });
      return products;
    } else {
      List prod = network.response;
      prod.forEach((element) {
        products.add(Product.fromJson(element));
      });
      return products;
    }
  }

  Future retry() async {
    setState(() {
      networkError = false;
      networkStatusCode = null;
    });
    _getCategoryProducts = getCategoryProducts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.args['catName'].toUpperCase(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: FutureBuilder(
            future: _getCategoryProducts,
            builder: (context, snapshot) {
              if (networkError) {
                return NetworkError(retry, statusCode: networkStatusCode);
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data.length == 0) {
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.error,
                          size: 100.0,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Nenhum produto disponível na categoria selecionada.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return ProductBox(snapshot.data, widget.args['code']);
              }
            },
          ),
        ),
      ),
    );
  }
}
