import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/components/text_input.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:provider/provider.dart';

enum SelectedGender { masculino, feminino }

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //SelectedGender _selectedGender = SelectedGender.masculino;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('CADASTRO'),
      ),
      body: Consumer<UserModel>(builder: (context, data, child) {
        return ModalProgressHUD(
          inAsyncCall: data.isLoading,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                Text('Seu nome'),
                SizedBox(height: 5.0),
                TextInput(
                  isRequired: true,
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  hintText: 'Informe seu nome completo',
                ),
                SizedBox(height: 10.0),
                Text('Seu email'),
                SizedBox(height: 5.0),
                TextInput(
                  isRequired: true,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  hintText: 'Informe seu email',
                ),
                SizedBox(height: 10.0),
                Text('Sua senha'),
                SizedBox(height: 5.0),
                TextInput(
                  isRequired: true,
                  controller: _passwordController,
                  textCapitalization: TextCapitalization.none,
                  hintText: 'Informe uma senha',
                  obscureText: true,
                ),

//              SizedBox(height: 16.0),
//              Text('Gênero'),
//              Row(
//                children: <Widget>[
//                  Radio(
//                    visualDensity: VisualDensity.compact,
//                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                    groupValue: _selectedGender,
//                    value: SelectedGender.masculino,
//                    onChanged: (value) {
//                      setState(() {
//                        _selectedGender = value;
//                      });
//                    },
//                  ),
//                  Text('Masculino'),
//                  Radio(
//                    groupValue: _selectedGender,
//                    value: SelectedGender.feminino,
//                    onChanged: (SelectedGender value) {
//                      setState(() {
//                        _selectedGender = value;
//                      });
//                    },
//                  ),
//                  Text('Feminino'),
//                ],
//              ),
                SizedBox(height: 20.0),
                SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        dynamic resRegister =
                            await Provider.of<UserModel>(context, listen: false)
                                .signUp(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        if (resRegister != null) {
                          _registerFail(resRegister);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/app', (route) => false);
                        }
                      }
                    },
                    textColor: Colors.white,
                    color: kPrimaryColor,
                    child: Text(
                      'Criar conta',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ja tenho uma conta.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _registerFail(dynamic msg) async {
    List<String> error = [];
    msg.forEach((item) => error.add(item));
    final string = error.reduce((value, element) => value + '\n' + element);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(string),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
    await Future.delayed(Duration(seconds: 4));
  }
}
