import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.pushNamed(context, '/settings/profile',
                      arguments: context.read<UserModel>().userData),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_circle, color: Colors.grey[600]),
                            SizedBox(width: 12.0),
                            Text(
                              'Meus dados',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () =>
                      Navigator.pushNamed(context, '/settings/address'),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey[600]),
                            SizedBox(width: 12.0),
                            Text(
                              'Endereços',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () =>
                      Navigator.pushNamed(context, '/settings/payment'),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet,
                                color: Colors.grey[600]),
                            SizedBox(width: 12.0),
                            Text(
                              'Formas de pagamento',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'MAIS OPÇÕES',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: Colors.grey[700],
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    NavKey.pageController.animateToPage(
                      3,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.help_outline, color: Colors.grey[600]),
                            SizedBox(width: 12.0),
                            Text(
                              'Ajuda',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey[600]),
                            SizedBox(width: 12.0),
                            Text(
                              'Sobre',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Provider.of<UserModel>(context, listen: false)
                      .logOut(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.exit_to_app, color: Colors.grey[600]),
                            SizedBox(width: 12.0),
                            Text(
                              'Sair',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
