// import 'package:flutter/material.dart';
// import 'package:mystore/models/product_model.dart';

// class ProductOptions extends StatelessWidget {
//   final Product product;
//   final Function setModalState;
//   ProductOptions(this.product, this.setModalState);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: product.variants.map((item) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.name,
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//                 SizedBox(height: 5.0),
//                 Row(
//                   children: item.options
//                       .where((element) => element.qtd >= 1)
//                       .map((s) {
//                     print(s.value);
//                     return GestureDetector(
//                       onTap: () {
//                         if (item.optionsType == 'size') {
//                           // setModalState(() {
//                           //   size = s.value;
//                           //   qtd = 1;
//                           // });
//                           // setState(() {
//                           //   size = s.value;
//                           //   qtd = 1;
//                           // });
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: Container(
//                           width: 50.0,
//                           height: 40.0,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.red,
//                               width: 1.0,
//                             ),
//                             borderRadius: BorderRadius.circular(4.0),
//                           ),
//                           child: Text(
//                             s.value,
//                             style: TextStyle(
//                               color: Colors.grey[400],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           'Quantidade',
//           style: TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//         SizedBox(height: 5.0),
//         Container(
//           width: 120.0,
//           height: 45.0,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.grey[400],
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(4.0),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.remove,
//                     color: Colors.grey[400],
//                   ),
//                   onPressed: () {
//                     // if (qtd >= 2) {
//                     //   setModalState(() {
//                     //     setState(() {
//                     //       qtd--;
//                     //     });
//                     //   });
//                     // }
//                   },
//                 ),
//               ),
//               Text('0'),
//               IconButton(
//                 icon: Icon(
//                   Icons.add,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   // int stock = product.variants
//                   //     .firstWhere(
//                   //         (element) =>
//                   //             element['size'] == size,
//                   //         orElse: () => 0)['qtd'];
//                   // if (qtd < stock) {
//                   //   setModalState(() {
//                   //     setState(() {
//                   //       qtd++;
//                   //     });
//                   //   });
//                   // }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
