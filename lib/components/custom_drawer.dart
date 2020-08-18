import 'package:flutter/material.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/tiles/drawer_tile.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  Widget _buildDrawerBack() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 203, 236, 241),
              Colors.white,
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, data, child) {
      return Drawer(
        child: Stack(
          children: <Widget>[
            _buildDrawerBack(),
            ListView(
              padding: EdgeInsets.only(left: 32.0, top: 16.0),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.only(
                      left: 0.0, top: 16.0, right: 8.0, bottom: 16.0),
                  height: 170.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 20.0,
                        left: 0.0,
                        child: Text(
                          'MyStore',
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Visibility(
                        visible: data.isLoggedIn,
                        child: Positioned(
                          right: 15.0,
                          top: 15.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/settings');
                            },
                            child: Icon(
                              Icons.settings,
                              size: 30.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        width: 250.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${data.isLoggedIn ? "Bem-vindo(a) " + data.userData.name + ", " : ""}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Consumer<UserModel>(
                              builder: (context, data, child) {
                                if (data.isLoggedIn) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      data.logOut(context);
                                    },
                                    child: Text(
                                      'Sair',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/auth/login');
                                    },
                                    child: Text(
                                      'Entre ou cadastre-se',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                DrawerTile(Icons.home, 'Início', pageController, 0),
                DrawerTile(Icons.list, 'Categorias', pageController, 1),
                DrawerTile(Icons.location_on, 'Lojas', pageController, 2),
                DrawerTile(Icons.playlist_add_check, 'Meus Pedidos',
                    pageController, 3),
                DrawerTile(Icons.vpn_key, 'Testes', pageController, 4),
              ],
            )
          ],
        ),
      );
    });
  }
}
