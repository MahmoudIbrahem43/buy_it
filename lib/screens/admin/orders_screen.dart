import 'package:buy_it/constanse.dart';
import 'package:buy_it/models/order.dart';
import 'package:buy_it/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_details.dart';

class OrdersScreen extends StatelessWidget {
  static String id = 'OrdersScreen';
  Store store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: store.loadOrders(),
        builder: (context, AsyncSnapshot? snapshot) {
          if (snapshot!.hasData) {
            List<Order> orders = [];
            for (var doc in snapshot.data!.docs) {
              var data = doc.data();
              orders.add(Order(
                documentId: doc.id,
                totalPrice: data[KTotalPrice],
                address: data[KAddress],
              ));
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetails.id,
                        arguments: orders[index].documentId);
                  },
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
                            'Address : ${orders[index].address}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Total Price : ${orders[index].totalPrice}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(
            child: Text('LOADING.....'),
          );
        },
      ),
    );
  }
}
