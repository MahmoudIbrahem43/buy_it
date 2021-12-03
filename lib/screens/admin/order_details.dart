import 'package:buy_it/models/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constanse.dart';

class OrderDetails extends StatelessWidget {
  static String id = 'OrderDetails';
  Store store = Store();

  @override
  Widget build(BuildContext context) {
    String? documentId = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: store.loadOrderDetails(documentId),
        builder: (context, AsyncSnapshot? snapshot) {
          if (snapshot!.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data!.docs) {
              var data = doc.data();
              products.add(
                Product(
                  pName: data[kProductName],
                  pPrice: data[kProductPrice].toString(),
                  pCategory: data[kProductCategory].toString(),
                  pLocation: data[kProductLocation].toString(),
                  pDescription: data[kProductDescription].toString(),
                  quantity: data[KQuatity],
                ),
              );
            }
            return Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      color: KSecondColor,
                      height: MediaQuery.of(context).size.height * .2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Name :${products[index].pName}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'price : ${products[index].pPrice}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Quantity : ${products[index].pCategory.toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Quantity : ${products[index].quantity.toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: KMainColor,
                        ),
                        child: Text(
                          'confirm',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: KMainColor,
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ]);
          } else {
            return Center(child: Text('LOADING..'));
          }
        },
      ),
    );
  }
}
