import 'package:flutter/material.dart';
import 'package:mystore/datas/product_data.dart';
import 'package:mystore/services/api.dart';
import 'package:mystore/tiles/product_tile.dart';

class Category extends StatelessWidget {
  final args;
  //final String catId;

  Category(this.args);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            args['catName'],
          ),
          bottom: TabBar(
            indicatorColor: Colors.grey[400],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[300],
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.grid_on,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
            future: Api.productsByCategory(args['catId']),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data.data.length == 0) {
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
                return TabBarView(
                  //physics: NeverScrollableScrollPhysics(),
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4.0,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        ProductData data = ProductData.fromMap(
                          snapshot.data.data[index],
                        );
                        return ProductTile('grid', data);
                      },
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        ProductData data = ProductData.fromMap(
                          snapshot.data.data[index],
                        );
                        return ProductTile('list', data);
                      },
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
