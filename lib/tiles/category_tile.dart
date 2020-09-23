import 'package:flutter/material.dart';
import 'package:mystore/components/image_loader.dart';

class CategoryTile extends StatelessWidget {
  final data;

  CategoryTile(this.data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: buildCachedNImage(
            image: data['icon'],
            iconSize: 50.0,
            iconColor: Colors.black54,
          ),
        ),
      ),
      title: Text(data['name']),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        //Get.to(CategoryScreen(catName: data['name'], catId: data['_id']));
        Navigator.pushNamed(context, '/category', arguments: {
          'catName': data['name'],
          'catId': data['_id'],
          'code': data['code'],
        });
      },
    );
  }
}
