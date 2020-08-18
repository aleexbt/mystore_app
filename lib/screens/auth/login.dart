import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/components/text_input.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final int redirectTimes;
  const Login({Key key, this.redirectTimes}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entrar'),
      ),
      body: Consumer<UserModel>(
        builder: (context, data, child) {
          return ModalProgressHUD(
            inAsyncCall: data.isLoading,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  Text('Seu email'),
                  SizedBox(height: 5.0),
                  TextInput(
                    isRequired: true,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    hintText: 'Seu email',
                  ),
                  SizedBox(height: 10.0),
                  Text('Sua senha'),
                  SizedBox(height: 5.0),
                  TextInput(
                    isRequired: true,
                    controller: _passwordController,
                    textCapitalization: TextCapitalization.none,
                    hintText: 'Sua senha',
                    obscureText: true,
                  ),
                  SizedBox(height: 5.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () async {
                        if (_emailController.text.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Informe seu e-mail para recuperar a senha.'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          await Future.delayed(Duration(seconds: 2));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Acabamos de te enviar um e-mail com um link para redefinir sua senha.'),
                              backgroundColor: Colors.teal,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          await Future.delayed(Duration(seconds: 2));
                        }
                      },
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Esqueceu sua senha?',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(
                    height: 50.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          String resLogin = await Provider.of<UserModel>(
                                  context,
                                  listen: false)
                              .signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (resLogin != null) {
                            _onFail(resLogin);
                          } else {
                            if (widget.redirectTimes != null) {
                              for (var i = 0; i < widget.redirectTimes; i++) {
                                Navigator.pop(context);
                              }
                            }
                            // Navigator.pop(context);
                            // Navigator.pop(context);
                            // Navigator.pushReplacementNamed(
                            //     context, '/settings');

                          }
                        }
                      },
                      textColor: Colors.white,
                      color: kPrimaryColor,
                      child: Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/auth/register');
                    },
                    child: Text(
                      'Quero criar minha conta.',
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
        },
      ),
    );
  }

  void _onFail(String msg) async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    await Future.delayed(Duration(seconds: 2));
  }
}
