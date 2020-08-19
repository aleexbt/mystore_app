import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/components/text_input.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final profileData;

  const Profile({Key key, this.profileData}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSavingData = false;

  MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  void updateUser() async {
    setState(() {
      _isSavingData = true;
    });
    String token = Provider.of<UserModel>(context, listen: false).token;
    var userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text.replaceAll(RegExp("[^0-9]+"), ''),
      'cpf': _cpfController.text.replaceAll(RegExp("[^0-9]+"), ''),
    };
    Provider.of<UserModel>(context, listen: false).updateUser(userData);
    var response = await Api.updateUser(userData, token);
    setState(() {
      _isSavingData = false;
    });
    if (response.data['success']) {
      _saveResponse(response.data['msg'], Colors.teal, 4);
    } else {
      _saveResponse(response.data['msg'], Colors.red, 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserModel>(context).userData;
    _nameController.text = userData.name;
    _emailController.text = userData.email;
    _phoneController.text = userData.phone ?? null;
    _cpfController.text = CPF.format(userData.cpf) ?? null;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Meus dados'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(MdiIcons.checkBold),
              onPressed: () => updateUser(),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSavingData,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Text('Nome completo'),
                SizedBox(height: 5.0),
                TextInput(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  hintText: 'Nome completo',
                ),
                SizedBox(height: 10.0),
                Text('E-mail'),
                SizedBox(height: 5.0),
                TextInput(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Endereço de email',
                ),
                SizedBox(height: 10.0),
                Text('Telefone'),
                SizedBox(height: 5.0),
                TextInput(
                  isRequired: false,
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  hintText: 'Número de telefone',
                ),
                SizedBox(height: 10.0),
                Text('CPF'),
                SizedBox(height: 5.0),
                TextInput(
                  isRequired: false,
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [cpfFormatter],
                  hintText: 'Número do CPF',
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveResponse(String text, Color color, int duration) async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        duration: Duration(seconds: duration),
      ),
    );
    await Future.delayed(Duration(seconds: duration));
  }
}
