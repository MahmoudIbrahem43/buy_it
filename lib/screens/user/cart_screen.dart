import 'package:buy_it/constanse.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/provider/cart_item.dart';
import 'package:buy_it/screens/user/home_page.dart';
import 'package:buy_it/screens/user/product_info.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static String id = 'CartScreen';

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'MY CART',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: products.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTapUp: (details) {
                            customShowMenu(details, context, products[index]);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .15,
                              color: KSecondColor,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.height *
                                        .15 /
                                        2,
                                    backgroundImage:
                                        AssetImage(products[index].pLocation),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        products[index].pName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        products[index].pPrice,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 120,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        products[index].quantity.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
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
                        showCustomDialog(products, context);
                      },
                      child: Text(
                        'ORDER',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 230),
                    child: Container(
                      color: Colors.white38,
                      height: 50,
                      width: 100,
                      child: Text(
                        'NO ITEM SELECTED !',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .4),
                  Container(
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
                        Navigator.pushNamed(context, HomePage.id);
                      },
                      child: Text(
                        'SHOP NOW',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void customShowMenu(details, context, product) async {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx2 = MediaQuery.of(context).size.width;
    double dy2 = MediaQuery.of(context).size.height;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
        items: [
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              CartItem cartItem = Provider.of<CartItem>(context, listen: false);
              cartItem.deleteProduct(product);
              Navigator.pushNamed(context, ProductInfo.id, arguments: product);
            },
            child: Text('edit'),
          ),
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              CartItem cartItem = Provider.of<CartItem>(context, listen: false);
              cartItem.deleteProduct(product);
            },
            child: Text('delete'),
          ),
        ]);
  }

  void showCustomDialog(List<Product> products, context) async {
    var price = getTotalPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        MaterialButton(
          onPressed: () {
            try {
              Store _store = Store();
              _store.storeOrders(
                {KTotalPrice: price, KAddress: address},
                products,
              );
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Order Saved')));
              Navigator.pop(context);
            } catch (ex) {
              print(ex.toString());
            }
          },
          child: Text(
            'Confirm',
          ),
        )
      ],
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(
          hintText: 'Enter Your address',
        ),
      ),
      title: Text('Total price : ${price}'),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotalPrice(List<Product> products) {
    var price = 0;
    for (var prodcut in products) {
      price += prodcut.quantity! * int.parse(prodcut.pPrice);
    }

    return price;
  }
}
