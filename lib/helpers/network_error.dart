import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';

class NetworkError extends StatelessWidget {
  final Function retry;

  NetworkError(this.retry);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 6),
          SvgPicture.asset(
            'assets/disconnected.svg',
            semanticsLabel: 'Sem conexão',
            width: 500.0,
          ),
          SizedBox(height: 10.0),
          Text(
            'Sem conexão',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Verifique sua conexão e tente novamente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => retry(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Tentar novamente',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
