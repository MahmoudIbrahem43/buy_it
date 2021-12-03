import 'package:buy_it/models/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_logo.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../constanse.dart';

class EditProduct extends StatelessWidget {
  static String id = 'EditProduct';
  late String _name, _price, _description, _category, _imageLocation;
  final _globalKey = GlobalKey<FormState>();
  final Store _store = Store();

  @override
  Widget build(BuildContext context) {
    Product? product = ModalRoute.of(context)!.settings.arguments as Product?;

    return Scaffold(
      backgroundColor: KMainColor,
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomLogo(),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    hint: 'Product name',
                    icon: Icons.title,
                    onClick: (value) {
                      _name = value!;
                    }),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Product price',
                  icon: Icons.price_change,
                  onClick: (value) {
                    _price = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Product Description',
                  icon: Icons.description,
                  onClick: (value) {
                    _description = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Product Category ',
                  icon: Icons.category,
                  onClick: (value) {
                    _category = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Product Location',
                  icon: Icons.location_city,
                  onClick: (value) {
                    _imageLocation = value!;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Builder(
                  //..to show snackbar and handle snackbar exception
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      if (_globalKey.currentState!.validate()) {
                        _globalKey.currentState!.save();
                        _store.editProduct(
                          ({
                            kProductName: _name,
                            kProductPrice: _price,
                            kProductDescription: _description,
                            kProductCategory: _category,
                            kProductLocation: _imageLocation,
                          }),
                          product!.pId,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Something went wrong please try again !')));
                      }
                    },
                    child: Text(
                      '  Save  ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
