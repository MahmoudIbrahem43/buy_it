import 'package:buy_it/constanse.dart';
import 'package:buy_it/provider/adminMood.dart';
import 'package:buy_it/provider/cart_item.dart';
import 'package:buy_it/provider/modelHud.dart';
import 'package:buy_it/screens/admin/add_product.dart';
import 'package:buy_it/screens/admin/admin_home.dart';
import 'package:buy_it/screens/admin/edit_product.dart';
import 'package:buy_it/screens/admin/mange_product.dart';
import 'package:buy_it/screens/admin/order_details.dart';
import 'package:buy_it/screens/admin/orders_screen.dart';
import 'package:buy_it/screens/user/cart_screen.dart';
import 'package:buy_it/screens/user/home_page.dart';
import 'package:buy_it/screens/login_screen.dart';
import 'package:buy_it/screens/signup_screen.dart';
import 'package:buy_it/screens/user/product_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buy_it/screens/user/product_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  // These two lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedin = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('LOADING...'),
              ),
            ),
          );
        }
        isUserLoggedin = snapshot.data!.getBool(KKeepUserLoggedIN) ?? false;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ModelHud>(create: (context) => ModelHud()),
            ChangeNotifierProvider<AdminMood>(create: (context) => AdminMood()),
            ChangeNotifierProvider<CartItem>(create: (context) => CartItem()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: isUserLoggedin ? HomePage.id : LoginScreen.id,
            routes: {
              OrderDetails.id: (context) => OrderDetails(),
              OrdersScreen.id: (context) => OrdersScreen(),
              ProductInfo.id: (context) => ProductInfo(),
              LoginScreen.id: (context) => LoginScreen(),
              SignupScreen.id: (context) => SignupScreen(),
              AdminHome.id: (context) => AdminHome(),
              HomePage.id: (context) => HomePage(),
              AddProduct.id: (context) => AddProduct(),
              EditProduct.id: (context) => EditProduct(),
              MangerProduct.id: (context) => MangerProduct(),
              CartScreen.id: (context) => CartScreen(),
            },
          ),
        );
      },
    );
  }
}
