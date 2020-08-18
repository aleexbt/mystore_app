import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/services/api.dart';
import 'package:mystore/tiles/category_tile.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Future _getCategories;

  @override
  void initState() {
    super.initState();
    _getCategories = Api.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/cart'),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 20.0),
              child: Badge(
                badgeContent: Text(
                  Provider.of<CartModel>(context).productCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
                child: Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getCategories,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var dividedTiles = ListTile.divideTiles(
                    tiles: snapshot.data.data.map<Widget>((doc) {
                      return CategoryTile(doc);
                    }).toList(),
                    color: Colors.grey[500])
                .toList();
            return ListView(
              children: dividedTiles,
            );
          }
        },
      ),
    );
  }
}
