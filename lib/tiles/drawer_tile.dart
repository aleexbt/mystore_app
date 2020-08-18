import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  DrawerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);
          pageController.animateToPage(page,
              duration: Duration(milliseconds: 600), curve: Curves.easeOutSine);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: pageController.page.round() == page
                    ? Colors.blue
                    : Colors.black,
              ),
              SizedBox(width: 32.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: pageController.page.round() == page
                      ? Colors.blue
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
