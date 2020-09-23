import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/product_model.dart';

class SelectRoupas extends StatefulWidget {
  final Product productData;
  final Function successCallback;
  final Function setSize;
  SelectRoupas(this.productData, this.successCallback, this.setSize);

  @override
  _SelectRoupasState createState() => _SelectRoupasState();
}

class _SelectRoupasState extends State<SelectRoupas> {
  List<ProductVariants> variants = [];
  String selectedSize;

  Map<String, int> sortedSize = {
    'PP': 0,
    'P': 1,
    'M': 2,
    'G': 3,
    'GG': 4,
    'XG': 5,
  };

  @override
  void initState() {
    super.initState();
    setVariants();
  }

  void setVariants() {
    Product product = widget.productData;
    for (var i = 0; i < product.variants.length; i++) {
      setState(() {
        variants.add(
          ProductVariants(
            size: product.variants[i].size,
            qtd: product.variants[i].qtd,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        Set<String> sizeSet = Set<String>();
        variants.sort((a, b) => sortedSize[a.size] - sortedSize[b.size]);
        List<ProductVariants> sizesList =
            variants.where((item) => sizeSet.add(item.size)).toList();
        Iterable<ProductVariants> colorList =
            variants.where((item) => item.size == selectedSize).length > 0
                ? variants.where((item) => item.size == selectedSize)
                : variants;
        return Visibility(
          visible: sizesList.length > 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tamanho',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: sizesList.map(
                  (s) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = s.size;
                          widget.setSize(s.size, s.qtd);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 45.0,
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            minWidth: 45.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: s.size == selectedSize
                                  ? kPrimaryColor
                                  : Colors.grey[400],
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              s.size.toUpperCase(),
                              style: TextStyle(
                                color: s.size == selectedSize
                                    ? kPrimaryColor
                                    : Colors.grey[400],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
