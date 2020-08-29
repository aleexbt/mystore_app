import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';

class NetworkError extends StatelessWidget {
  final int statusCode;
  final String errorMsg;
  final Function retry;

  NetworkError(this.retry, {this.statusCode, this.errorMsg});

  String errorMessage() {
    if (statusCode == 523) {
      return 'Verifique a qualidade da sua conexão e tente novamente.';
    } else if (statusCode == 524) {
      return 'Parece que nosso servidor está sobrecarregado, tente novamente mais tarde.';
    } else if (statusCode == 502) {
      return 'Verifique sua conexão e tente novamente.';
    } else {
      return 'Ops, parece que nosso servidor está passando por dificuldades neste momento.';
    }
  }

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
            'Ocorreu um erro',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            errorMessage(),
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
