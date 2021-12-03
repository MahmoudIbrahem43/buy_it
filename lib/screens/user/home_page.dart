import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/login_screen.dart';
import 'package:buy_it/screens/user/cart_screen.dart';
import 'package:buy_it/screens/user/product_info.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/product_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constanse.dart';
import '../../functions.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  late List<Product> _products = [];
  final Auth auth = Auth();
  // FirebaseUser _loggedUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: KUnactiveColors,
              currentIndex: _bottomBarIndex,
              fixedColor: KMainColor,
              onTap: (value) async {
                if (_bottomBarIndex == 2) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.clear();
                  await auth.signOut();
                }
                setState(() {
                  _bottomBarIndex = value;
                  Navigator.popAndPushNamed(context,LoginScreen.id);
                });
              },
              items: [
                BottomNavigationBarItem(
                    label: 'Test', icon: Icon(Icons.person)),
                BottomNavigationBarItem(
                    label: 'Test', icon: Icon(Icons.person)),
                BottomNavigationBarItem(
                    label: 'Sign Out', icon: Icon(Icons.close)),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: KMainColor,
                onTap: (value) {
                  setState(
                    () {
                      _tabBarIndex = value;
                    },
                  );
                },
                tabs: [
                  Text(
                    'jackets',
                    style: TextStyle(
                      color: _tabBarIndex == 0 ? Colors.black : KUnactiveColors,
                      fontSize: _tabBarIndex == 0 ? 16 : null,
                    ),
                  ),
                  Text(
                    't-shirts',
                    style: TextStyle(
                      color: _tabBarIndex == 1 ? Colors.black : KUnactiveColors,
                      fontSize: _tabBarIndex == 1 ? 16 : null,
                    ),
                  ),
                  Text(
                    'trousers',
                    style: TextStyle(
                      color: _tabBarIndex == 2 ? Colors.black : KUnactiveColors,
                      fontSize: _tabBarIndex == 2 ? 16 : null,
                    ),
                  ),
                  Text(
                    'shoes',
                    style: TextStyle(
                      color: _tabBarIndex == 3 ? Colors.black : KUnactiveColors,
                      fontSize: _tabBarIndex == 3 ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                jacketView(),
                productView(KTshirts, _products),
                productView(KTrousers, _products),
                productView(KShoes, _products),
              ],
            ),
          ),
        ),
        Material(
          child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 45, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discover',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    GestureDetector(
                      child: Icon(Icons.shopping_cart),
                      onTap: () {
                        Navigator.pushNamed(context, CartScreen.id);
                      },
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget jacketView() {
    Store _store = Store();
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProduct(),
      builder: (context, AsyncSnapshot? snapshot) {
        if (snapshot!.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data!.docs) {
            var data = doc.data();
            products.add(
              Product(
                  pId: doc.id,
                  pName: data[kProductName],
                  pCategory: data[kProductCategory],
                  pDescription: data[kProductDescription],
                  pLocation: data[kProductLocation],
                  pPrice: data[kProductPrice]),
            );
          }
          _products = [...products];
          products.clear();
          products = getProductsByCategorey(KJackets, _products);

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
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black,
                            ),
                            height: 60,
                            width: MediaQuery.of(context).size.width,
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
        return Center(child: Text('Loading....'));
      },
    );
  }
}
