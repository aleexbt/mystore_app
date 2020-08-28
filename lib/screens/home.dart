import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/services/api.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool networkError = false;
  Future _getConfig;

  @override
  void initState() {
    super.initState();
    _getConfig = getConfig();
  }

  Future getConfig() async {
    var response = await Api.appConfig();
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
    _getConfig = getConfig();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 211, 110, 130),
                Color.fromARGB(255, 253, 181, 168),
              ],
            ),
          ),
        );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBodyBack(),
          CustomScrollView(
            //physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                //pinned: true,
                stretch: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'MyStore',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                  titlePadding: EdgeInsets.all(15.0),
                ),
              ),
              FutureBuilder(
                future: _getConfig,
                builder: (context, snapshot) {
                  if (networkError) {
                    return SliverToBoxAdapter(
                      child: NetworkError(retry),
                    );
                  }
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return SliverStaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 1.0,
                        staggeredTiles: snapshot.data['config']['home']
                            .map<StaggeredTile>((doc) {
                          return StaggeredTile.count(doc['x'], doc['y']);
                        }).toList(),
                        children:
                            snapshot.data['config']['home'].map<Widget>((doc) {
                          // return FadeInImage.memoryNetwork(
                          //   placeholder: kTransparentImage,
                          //   image: doc['image'],
                          //   fit: BoxFit.cover,
                          // );
                          return buildCachedNImage(
                            image: doc['image'],
                            iconSize: 70.0,
                            iconColor: Colors.white54,
                          );
                        }).toList());
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
