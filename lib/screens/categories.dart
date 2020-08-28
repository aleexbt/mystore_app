import 'package:flutter/material.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/services/api.dart';
import 'package:mystore/tiles/category_tile.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Future _getCategories;
  bool networkError = false;

  @override
  void initState() {
    super.initState();
    _getCategories = getCategories();
  }

  Future getCategories() async {
    var response = await Api.getCategories();
    if (response == null) {
      setState(() {
        networkError = true;
      });
      debugPrint('Erro no carregamento');
      return null;
    } else {
      return response;
    }
  }

  Future retry() async {
    setState(() {
      networkError = false;
    });
    _getCategories = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
      ),
      body: FutureBuilder(
        future: _getCategories,
        builder: (context, snapshot) {
          if (networkError) {
            return NetworkError(retry);
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var dividedTiles = ListTile.divideTiles(
                    tiles: snapshot.data.map<Widget>((doc) {
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
