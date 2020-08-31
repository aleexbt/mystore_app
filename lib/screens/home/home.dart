import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helpers/network_error.dart';
import 'package:mystore/helpers/no_glow_behavior.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/services/api.dart';

import 'components/products.dart';

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
  double top = 0.0;

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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              stretch: false,
              elevation: 0.0,
              expandedHeight: 80.0,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    centerTitle: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MyStore',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                        top > 92.0
                            ? Icon(
                                Icons.search,
                                color: kPrimaryColor,
                              )
                            : SizedBox(width: 0),
                      ],
                    ),
                    titlePadding: EdgeInsets.all(15.0),
                  );
                },
              ),

              // FlexibleSpaceBar(
              //   collapseMode: CollapseMode.pin,
              //   centerTitle: false,
              //   title: Text(
              //     'MyStore',
              //     style: TextStyle(
              //       color: kPrimaryColor,
              //       fontWeight: FontWeight.w600,
              //       fontSize: 20.0,
              //     ),
              //   ),
              //   titlePadding: EdgeInsets.all(15.0),
              // ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                    child: CarouselSlider(
                      options: CarouselOptions(height: 180.0, autoPlay: true),
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://www.macleans.ca/wp-content/uploads/2014/09/MAC36_WOMENS_CLOTHES_POST.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'DESTAQUE $i',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Você pode gostar',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Products(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
