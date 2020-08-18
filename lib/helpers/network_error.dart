import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  final Function retry;

  NetworkError(this.retry);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.fromLTRB(
          30.0, MediaQuery.of(context).size.height / 4, 30.0, 0.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 1.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error,
            size: 60.0,
            color: Colors.grey[500],
          ),
          SizedBox(height: 10.0),
          Text(
            'Não conseguimos conectar ao servidor. \nVerifique sua conexão.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            onPressed: () => retry(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tentar novamente',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Icon(
                  Icons.refresh,
                  color: Colors.grey[600],
                  size: 17.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
