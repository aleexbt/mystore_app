import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Items {
  String tamanho;
  String cor;
  int qtd;

  Items({this.tamanho, this.cor, this.qtd});

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        tamanho: json['size'],
        cor: json['color'],
        qtd: json['qtd'],
      );
}

class Teste extends StatefulWidget {
  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  List<Items> items = [];
  String uTamanho;
  String uCor;
  int qtdDisponivel = 0;

  @override
  void initState() {
    super.initState();

    getProduct();
  }

  getProduct() async {
    Dio dio = Dio();
    Response response = await dio
        .get('http://192.168.0.10:3000/products/5f603787cae57aa1c2009807');

    for (var i = 0; i < response.data['variants'].length; i++) {
      setState(() {
        items.add(
          Items(
            tamanho: response.data['variants'][i]['size'],
            cor: response.data['variants'][i]['color'],
            qtd: response.data['variants'][i]['qtd'],
          ),
        );
      });
    }

    Items selected = items.firstWhere((item) => item.qtd > 0, orElse: null);

    if (selected != null) {
      uTamanho = selected.tamanho;
      uCor = selected.cor;
      qtdDisponivel = selected.qtd;
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanhosSet = Set<String>();
    var tamanhos =
        items.where((item) => tamanhosSet.add(item.tamanho)).toList();

    var cores = items.where((item) => item.tamanho == uTamanho).length > 0
        ? items.where((item) => item.tamanho == uTamanho)
        : items;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tamanho'),
              Row(
                children: tamanhos.map((e) {
                  return FlatButton(
                    onPressed: () {
                      setState(() {
                        uTamanho = e.tamanho;
                        uCor = null;
                        qtdDisponivel = 0;
                      });
                    },
                    child: Text(e.tamanho),
                  );
                }).toList(),
              ),
              Text('Cor'),
              Row(
                children: cores.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          uCor = e.cor;
                          qtdDisponivel = e.qtd;
                        });
                      },
                      child: Text(e.cor),
                    ),
                  );
                }).toList(),
              ),
              Visibility(
                visible: uTamanho == null || uCor == null || qtdDisponivel == 0,
                child: Text('Por favor selecione um item.'),
              ),
              Visibility(
                visible: uTamanho != null && uCor != null && qtdDisponivel > 0,
                child: Text(
                    'Você selecionou o tamanho $uTamanho na cor $uCor.\n \n Temos $qtdDisponivel items disponíveis nessa cor.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
