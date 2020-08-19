import 'dart:convert';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mystore/components/text_input.dart';
import 'package:mystore/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class PaymentEditor extends StatefulWidget {
  final UserCard creditCardData;
  PaymentEditor({this.creditCardData});

  @override
  _PaymentEditorState createState() => _PaymentEditorState();
}

class _PaymentEditorState extends State<PaymentEditor> {
  String _selectedAddress;
  MaskTextInputFormatter ccFormatter = MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
  MaskTextInputFormatter expirationFormatter =
      MaskTextInputFormatter(mask: '##/##', filter: {"#": RegExp(r'[0-9]')});
  MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();
  final _expirationController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cpfController = TextEditingController();
  final storage = FlutterSecureStorage();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _cardId;
  Uuid uuid = Uuid();
  String _cardBrand = 'Unknown';

  @override
  void initState() {
    super.initState();
    if (widget.creditCardData != null) {
      _cardId = widget.creditCardData.id;
      _numberController.text =
          UserFunctions.ccFormatter(widget.creditCardData.number);
      _nameController.text = widget.creditCardData.name;
      _expirationController.text =
          UserFunctions.ccExpirationFormatter(widget.creditCardData.expiration);
      _cvvController.text = widget.creditCardData.cvv;
      _cpfController.text = CPF.format(widget.creditCardData.cpf);
      _cardBrand = widget.creditCardData.brand;
      setState(() {
        _selectedAddress = widget.creditCardData.billing.id;
      });
    }
    _numberController.addListener(() {
      checkCardBrand();
    });
  }

  void checkCardBrand() {
    var type = detectCCType(_numberController.text);
    String brand = 'Unknown';
    switch (type) {
      case CreditCardType.visa:
        brand = 'Visa';
        break;
      case CreditCardType.mastercard:
        brand = 'MasterCard';
        break;
      case CreditCardType.amex:
        brand = 'Amex';
        break;
      case CreditCardType.discover:
        brand = 'Discover';
        break;
      case CreditCardType.dinersclub:
        brand = 'DinersClub';
        break;
      case CreditCardType.jcb:
        brand = 'JCB';
        break;
      case CreditCardType.unionpay:
        brand = 'UnionPay';
        break;
      case CreditCardType.maestro:
        brand = 'Maestro';
        break;
      case CreditCardType.mir:
        brand = 'Mir';
        break;
      case CreditCardType.elo:
        brand = 'Elo';
        break;
      case CreditCardType.hiper:
        brand = 'Hiper';
        break;
      case CreditCardType.hipercard:
        brand = 'HiperCard';
        break;
      default:
        brand = 'Unknown';
    }

    setState(() {
      _cardBrand = brand;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _saveCreditCard() async {
      if (_formKey.currentState.validate() && _selectedAddress != null) {
        FocusScope.of(context).unfocus();
        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        final SharedPreferences prefs = await _prefs;
        final String _cardKey =
            _numberController.text.substring(_numberController.text.length - 4);

        var billing = userModel.userData.address
            .firstWhere((item) => item.id == _selectedAddress, orElse: null);

        final UserCard _cardData = UserCard.fromJson({
          'id': _cardId ?? uuid.v4(),
          'brand': _cardBrand,
          'number': _numberController.text.replaceAll(' ', ''),
          'name': _nameController.text,
          'expiration':
              _expirationController.text.replaceAll(RegExp("[^0-9]+"), ''),
          'cvv': _cvvController.text.replaceAll(RegExp("[^0-9]+"), ''),
          'cpf': _cpfController.text.replaceAll(RegExp("[^0-9]+"), ''),
          'billing': billing.toJson(),
        });

        List<String> cardKeys =
            prefs.getStringList('${userModel.userData.id}_cards') ?? [];

        if (widget.creditCardData != null) {
          final String _oldCardKey = widget.creditCardData.number
              .substring(widget.creditCardData.number.length - 4);

          cardKeys.remove(_oldCardKey);
          await storage.delete(key: _oldCardKey);
          await storage.write(key: _cardKey, value: json.encode(_cardData));

          userModel.editCard(_cardData);
          cardKeys.add(_cardKey);
          prefs.setStringList('${userModel.userData.id}_cards', cardKeys);
        } else {
          debugPrint('ADICIONOU NOVO CARTÃO \n $_cardKey');
          await storage.write(key: _cardKey, value: json.encode(_cardData));

          userModel.addCard(_cardData);

          cardKeys.add(_cardKey);
          prefs.setStringList('${userModel.userData.id}_cards', cardKeys);
        }
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.creditCardData != null
            ? 'Editar cartão'
            : 'Adicionar cartão'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(MdiIcons.checkBold),
              onPressed: () => _saveCreditCard(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0),
                Text('Número do cartão de crédito'),
                SizedBox(height: 5.0),
                TextInput(
                  controller: _numberController,
                  maxLength: 19,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ccFormatter],
                  hintText: 'Número do cartão',
                  suffixIcon: _cardBrand != 'Unknown'
                      ? Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: SvgPicture.asset(
                            'assets/credit_card_icons/${_cardBrand.toLowerCase()}.svg',
                            semanticsLabel: _cardBrand,
                            width: 0.0,
                            height: 0.0,
                          ),
                        )
                      : Icon(
                          Icons.credit_card,
                          color: kPrimaryColor,
                        ),
                ),
                SizedBox(height: 10.0),
                Text('Nome como impresso no cartão'),
                SizedBox(height: 5.0),
                TextInput(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  hintText: 'Nome como impresso no cartão',
                ),
                SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Validade (MM/AA)'),
                            SizedBox(height: 5.0),
                            TextInput(
                              controller: _expirationController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [expirationFormatter],
                              hintText: 'MM/AA',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Código de Seguraça'),
                            SizedBox(height: 5.0),
                            TextInput(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              hintText: 'CVV',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text('CPF'),
                SizedBox(height: 5.0),
                TextInput(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [cpfFormatter],
                  hintText: 'CPF do titular do cartão',
                ),
                SizedBox(height: 30.0),
                Text(
                  'ENDEREÇO DE COBRANÇA',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                    color: Colors.grey[500],
                    letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.start,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      Provider.of<UserModel>(context).userData.address.length,
                  itemBuilder: (context, index) {
                    var item = Provider.of<UserModel>(context).userData;
                    String street = '${item.address[index].street}';
                    String number = item.address[index].streetNumber != null
                        ? ', ${item.address[index].streetNumber}'
                        : '';
                    String complement = item.address[index].complement != null
                        ? ', ${item.address[index].complement}'
                        : '';
                    if (item.address != null && item.address.length > 0) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              setState(() {
                                _selectedAddress = item.address[index].id;
                              });
                            },
                            leading: Radio(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: item.address[index].id,
                                groupValue: _selectedAddress,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAddress = value;
                                  });
                                }),
                            title: Text(
                              street + number + complement,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                            subtitle: Text(
                                '${item.address[index].city} - ${item.address[index].state}'),
                          ),
                          Divider(),
                        ],
                      );
                    } else {
                      return Text('Você ainda não cadastrou nenhum endereço.');
                    }
                  },
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () =>
                      Navigator.pushNamed(context, '/settings/address_editor'),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Adicionar novo endereço',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
