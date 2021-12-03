import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/admin/edit_product.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buy_it/constanse.dart';

class MangerProduct extends StatefulWidget {
  static String id = 'MangerProduct';


  @override
  _MangerProductState createState() => _MangerProductState();
}

class _MangerProductState extends State<MangerProduct> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProduct(),
        builder: (context, AsyncSnapshot? snapshot) {
          if (snapshot!.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data!.docs) {
              var data = doc.data();
              products.add(
                Product(
                    pId: doc.id,
                    pName: data![kProductName],
                    pCategory: data[kProductCategory],
                    pDescription: data[kProductDescription],
                    pLocation: data[kProductLocation],
                    pPrice: data[kProductPrice]),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .6, crossAxisCount: 2),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
                  onTapUp: (details) {
                    double dx = details.globalPosition.dx;
                    double dy = details.globalPosition.dy;
                    double dx2 = MediaQuery.of(context).size.width;
                    double dy2 = MediaQuery.of(context).size.height;
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                      items: [
                        MyPopupMenuItem(
                          onClick: () {
                            Navigator.pushNamed(context, EditProduct.id,arguments: products[index]);
                          },
                          child: Text('edit'),
                        ),
                        MyPopupMenuItem(
                          onClick: () {
                            _store.deleteProduct(products[index].pId);
                            Navigator.pop(context);
                          },
                          child: Text('delete'),
                        ),
                      ],
                    );
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
                                  color: Colors.black),
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
                                    )
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
          return Center(child: Text('Loading....'));
        },
      ),
    );
  }
}


