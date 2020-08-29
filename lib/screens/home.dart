import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/helpers/no_glow_behavior.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/services/api.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool networkError = false;
  int networkStatusCode;
  Future _getConfig;

  @override
  void initState() {
    super.initState();
    _getConfig = getConfig();
  }

  Future getConfig() async {
    NetworkHandler network = await Api.appConfig();
    if (network.error) {
      setState(() {
        networkError = true;
        networkStatusCode = network.statusCode;
      });
    } else {
      return network.response;
    }
  }

  Future retry() async {
    setState(() {
      networkError = false;
      networkStatusCode = null;
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
          ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  snap: true,
                  stretch: false,
                  elevation: 0.0,
                  expandedHeight: 80.0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    centerTitle: true,
                    title: Text(
                      'MyStore',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 22.0,
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
                        child:
                            NetworkError(retry, statusCode: networkStatusCode),
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
                          children: snapshot.data['config']['home']
                              .map<Widget>((doc) {
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
            ),
          )
        ],
      ),
    );
  }
}
