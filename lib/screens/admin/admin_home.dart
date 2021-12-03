import 'package:buy_it/screens/admin/add_product.dart';
import 'package:buy_it/screens/admin/mange_product.dart';
import 'package:buy_it/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:buy_it/constanse.dart';

import 'orders_screen.dart';

class AdminHome extends StatelessWidget {
  static String id = 'AdminHome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMainColor,
      body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          CustomLogo(),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.add,
                  color: KMainColor,
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  primary: KSecondColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                label: Text(
                  'Add Product',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AddProduct.id);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.settings,
                  color: KMainColor,
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: KSecondColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                label: Text(
                  'Edit Product',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, MangerProduct.id);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.reorder,
                  color: KMainColor,
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: KSecondColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                label: Text(
                  ' View Order',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                   Navigator.pushNamed(context, OrdersScreen.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
