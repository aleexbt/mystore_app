import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/services/api.dart';
import 'package:mystore/tiles/place_tile.dart';
import 'package:provider/provider.dart';

class Places extends StatefulWidget {
  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lojas'),
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
        future: Api.appConfig(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data['config']['places'].length,
                itemBuilder: (context, index) {
                  return PlaceTile(snapshot.data['config']['places'][index]);
                });
          }
        },
      ),
    );
  }
}
