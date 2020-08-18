import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final data;
  PlaceTile(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200.0,
              child: buildCachedNImage(
                image: data['image'],
                iconSize: 60.0,
                iconColor: Colors.black54,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data['address'],
                  textAlign: TextAlign.start,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Ver no mapa'),
                      textColor: Colors.blue,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        launch(
                            'https://www.google.com/maps/search/?api=1&query=${data['lat']},${data['long']}');
                      },
                    ),
                    FlatButton(
                      child: Text('Ligar'),
                      textColor: Colors.blue,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        launch('tel:${data['phone']}');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
