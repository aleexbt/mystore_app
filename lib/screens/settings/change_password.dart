import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mystore/components/text_input.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPassword2Controller = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //bool _isSavingData = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Alterar senha'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(MdiIcons.checkBold),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Text('Senha atual'),
            SizedBox(height: 5.0),
            TextInput(
              controller: _currentPasswordController,
              textCapitalization: TextCapitalization.none,
              obscureText: true,
              hintText: 'Senha atual',
            ),
            SizedBox(height: 10.0),
            Text('Nova senha'),
            SizedBox(height: 5.0),
            TextInput(
              controller: _newPasswordController,
              textCapitalization: TextCapitalization.none,
              obscureText: true,
              hintText: 'Nova senha',
            ),
            SizedBox(height: 10.0),
            Text('Confirmar senha'),
            SizedBox(height: 5.0),
            TextInput(
              controller: _newPassword2Controller,
              textCapitalization: TextCapitalization.none,
              obscureText: true,
              hintText: 'Confirmar senha',
            ),
          ],
        ),
      ),
    );
  }
}
