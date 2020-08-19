import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/services/api.dart';
import 'package:mystore/tiles/order_tile.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  WebSocketChannel channel;
  Stream broadcastStream;
  List orderList = [];
  bool _isLoading = true;

  Future<List> getOrders() async {
    var response = await Api.getOrders(
        Provider.of<UserModel>(context, listen: false).token);
    setState(() {
      orderList = [];
      orderList.addAll(response);
      _isLoading = false;
    });
    return orderList;
  }

  void updateList(dynamic data) {
    int index =
        orderList.indexWhere((element) => element['_id'] == data['_id']);
    if (index != null && index >= 0) {
      orderList.removeAt(index);
      orderList.insert(index, data);
    } else {
      orderList.insert(0, data);
    }
  }

  @override
  void didChangeDependencies() {
    var userModel = Provider.of<UserModel>(context);
    if (userModel.isLoggedIn) {
      orderList = [];
      getOrders();
      channel = IOWebSocketChannel.connect(
          'wss://xelapps-mystore.herokuapp.com',
          headers: {
            'Authorization': Provider.of<UserModel>(context).token,
          });
      channel.sink.add('getOrders');
      broadcastStream = channel.stream.asBroadcastStream();
      handleWsStatus();
      super.didChangeDependencies();
    }
  }

  handleWsStatus() {
    broadcastStream.listen(
      (dynamic message) {
        debugPrint('Websocket: $message');
      },
      onDone: () => debugPrint('Websocket desconectado.'),
      onError: (error) => debugPrint('Ocorreu um erro no websocket.'),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height / 2.5;
    double height2 = MediaQuery.of(context).size.height / 3;
    UserModel userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus pedidos'),
      ),
      body: RefreshIndicator(
        onRefresh: getOrders,
        child: ListView(
          children: [
            !userModel.isLoggedIn
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        size: 100.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Text(
                          'Para acompanhar seus pedidos você precisa estar autenticado.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: orderList.length == 0
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: orderList.length == 0 && _isLoading,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, top: height, right: 8.0, bottom: 8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Visibility(
                        visible: orderList.length == 0 && !_isLoading,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, top: height2, right: 8.0, bottom: 8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error,
                                size: 100.0,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Você ainda não possui nenhum pedido.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: broadcastStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var response = json.decode(snapshot.data);
                            if (response['success']) {
                              updateList(response['orderData']);
                            }
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: orderList.length,
                              itemBuilder: (context, index) {
                                return OrderTile(orderList[index]);
                              },
                            );
                          } else {
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: orderList.length,
                              itemBuilder: (context, index) {
                                return OrderTile(orderList[index]);
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
