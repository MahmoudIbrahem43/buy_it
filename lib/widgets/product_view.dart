import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/user/product_info.dart';
import 'package:flutter/material.dart';

import '../functions.dart';

Widget productView(pCategorey, List<Product> allProduct) {
  List<Product> products = [];
  products = getProductsByCategorey(pCategorey, allProduct);
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: .6, crossAxisCount: 2),
    itemBuilder: (context, index) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductInfo.id,
              arguments: products[index]);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage(products[index].pLocation),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: .7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    // color: 2Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  ${products[index].pName} ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            ' \$ ${products[index].pPrice} ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    itemCount: products.length,
  );
}
