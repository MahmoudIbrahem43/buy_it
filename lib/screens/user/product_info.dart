import 'package:buy_it/constanse.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/provider/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    Product? product = ModalRoute.of(context)!.settings.arguments as Product?;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage(product!.pLocation),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 45, 25, 0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.shopping_cart),
                    onTap: () {
                      Navigator.pushNamed(context, CartScreen.id);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Opacity(
                  child: Container(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .25,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.pName}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            '${product.pCategory}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            '\$ ${product.pPrice}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Material(
                                  color: KMainColor,
                                  child: GestureDetector(
                                    onTap: addQuantity,
                                    child: SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '$count',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ClipOval(
                                child: Material(
                                  color: KMainColor,
                                  child: GestureDetector(
                                    onTap: subTractQuatity,
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  opacity: .6,
                ),
                Builder(
                  builder: (context) => Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: KMainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        addToCart(context, product);
                      },
                      child: Text(
                        'ADD TO CARD',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addQuantity() {
    setState(() {
      count++;
    });
  }

  void subTractQuatity() {
    setState(() {
      if (count > 1) {
        count--;
      }
    });
  }

  void addToCart(BuildContext context, Product product) {
    CartItem cartitem = Provider.of<CartItem>(context, listen: false);
    product.quantity = count;
    bool exist = false;
    var cartProducts = cartitem.products;
    for (var cartProduct in cartProducts) {
      if (cartProduct.pName == product.pName) {
        exist = true;
      }
    }
    if (exist) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('This Product Already Exist')));
    } else {
      cartitem.addProductToCart(product);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Added To Cart')));
    }
  }
}
