import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mystore/components/text_input.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddressEditor extends StatefulWidget {
  final UserAddress addressData;
  AddressEditor({this.addressData});

  @override
  _AddressEditorState createState() => _AddressEditorState();
}

class _AddressEditorState extends State<AddressEditor> {
  bool _validatedCep = false;
  String _validatedCepNumber;
  bool _isLoading = false;
  String _addressId;
  final _nameController = TextEditingController();
  final _cepController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _referenceController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Timer _debounce;
  int _debouncetime = 500;
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    UserAddress addressData = widget.addressData;
    if (widget.addressData != null) {
      _addressId = addressData.id;
      _nameController.text = addressData.name;
      _validatedCepNumber = UserFunctions.cepFormatter(addressData.zipcode);
      _cepController.text = UserFunctions.cepFormatter(addressData.zipcode);
      _addressController.text = addressData.street;
      _numberController.text = addressData.streetNumber;
      _complementController.text = addressData.complement;
      _referenceController.text = addressData.reference;
      _neighborhoodController.text = addressData.neighborhood;
      _cityController.text = addressData.city;
      _stateController.text = addressData.state;
      _validatedCep = true;
    }
    _cepController.addListener(_cepChanged);
    super.initState();
  }

  _cepChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () async {
      if (_cepController.text != "" &&
          _validatedCepNumber != _cepController.text &&
          _cepController.text.length == 9 &&
          _focus.hasFocus) {
        setState(() {
          _isLoading = true;
        });
        FocusScope.of(context).unfocus();
        var response = await Api.validateCep(_cepController.text);
        if (response.data['success']) {
          setState(() {
            _validatedCep = true;
            _validatedCepNumber = _cepController.text;
            _addressController.text = response.data['data']['street'];
            _neighborhoodController.text =
                response.data['data']['neighborhood'];
            _cityController.text = response.data['data']['city'];
            _stateController.text = response.data['data']['state'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _validatedCep = false;
            _validatedCepNumber = null;
            _isLoading = false;
          });
          debugPrint('CEP inválido');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var cepFormatter = MaskTextInputFormatter(
        mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.addressData == null ? 'Novo endereço' : 'Editar endereço'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(MdiIcons.checkBold),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isLoading = true;
                  });
                  Map<String, dynamic> userData = {
                    '_id': _addressId,
                    'name': _nameController.text,
                    'zipcode':
                        _validatedCepNumber.replaceAll(RegExp("[^0-9]+"), ''),
                    'street': _addressController.text,
                    'street_number': _numberController.text,
                    'complement': _complementController.text,
                    'reference': _referenceController.text,
                    'neighborhood': _neighborhoodController.text,
                    'city': _cityController.text,
                    'state': _stateController.text,
                  };
                  if (widget.addressData != null) {
                    await Api.updateAddress(userData,
                        Provider.of<UserModel>(context, listen: false).token);
                    Provider.of<UserModel>(context, listen: false)
                        .editAddress(UserAddress.fromJson(userData));
                  } else {
                    var response = await Api.addAddress(userData,
                        Provider.of<UserModel>(context, listen: false).token);
                    userData['_id'] = response.data['id'];
                    Provider.of<UserModel>(context, listen: false)
                        .addAddress(UserAddress.fromJson(userData));
                  }
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Apelido'),
                  SizedBox(height: 5.0),
                  TextInput(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    hintText: 'Apelido do endereço, por ex. \'Minha Casa\'.',
                    validatorText:
                        'Você precisa informar um apelido para o endereço.',
                  ),
                  SizedBox(height: 10.0),
                  Text('CEP'),
                  SizedBox(height: 5.0),
                  TextInput(
                    controller: _cepController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [cepFormatter],
                    hintText: 'Informe o CEP deste endereço.',
                    validatorText: 'Você precisa informar um CEP.',
                    focusNode: _focus,
                  ),
                  SizedBox(height: 10.0),
                  Text('Endereço'),
                  SizedBox(height: 5.0),
                  TextInput(
                    enabled: false,
                    isRequired: _validatedCep,
                    controller: _addressController,
                    hintText: 'Endereço',
                    validatorText: 'Você precisa informar um endereço.',
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextInput(
                          enabled: _validatedCep,
                          isRequired: _validatedCep,
                          controller: _numberController,
                          keyboardType: TextInputType.number,
                          hintText: 'Número',
                          validatorText: 'Você precisa informar um número.',
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 3,
                        child: TextInput(
                          enabled: _validatedCep,
                          isRequired: false,
                          controller: _complementController,
                          textCapitalization: TextCapitalization.sentences,
                          hintText: 'Complemento',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextInput(
                    enabled: _validatedCep,
                    isRequired: false,
                    controller: _referenceController,
                    textCapitalization: TextCapitalization.sentences,
                    hintText: 'Ponto de Referência.',
                  ),
                  SizedBox(height: 10.0),
                  Text('Bairro'),
                  SizedBox(height: 5.0),
                  TextInput(
                    enabled: false,
                    isRequired: false,
                    controller: _neighborhoodController,
                    hintText: 'Bairro',
                    validatorText: 'Você precisa informar um bairro.',
                  ),
                  SizedBox(height: 10.0),
                  Text('Cidade'),
                  SizedBox(height: 5.0),
                  TextInput(
                    enabled: false,
                    isRequired: false,
                    controller: _cityController,
                    hintText: 'Cidade',
                    validatorText: 'Você precisa informar uma cidade.',
                  ),
                  SizedBox(height: 10.0),
                  Text('Estado'),
                  SizedBox(height: 5.0),
                  TextInput(
                    enabled: false,
                    isRequired: false,
                    controller: _stateController,
                    hintText: 'Estado',
                    validatorText: 'Você precisa informar um estado.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
