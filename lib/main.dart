import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyShopApp());

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (ctx, auth, prev) => Products(
            auth.token,
            auth.userId,
            prev == null ? [] : prev.products,
          ),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (ctx, auth, prev) => Orders(
            auth.token,
            auth.userId,
            prev == null ? [] : prev.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.amber,
            accentColor: Colors.blueGrey[300],
            fontFamily: 'Lato',
            textTheme: ThemeData().textTheme.copyWith(
                  headline6: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                  ),
                  bodyText1: TextStyle(fontSize: 20),
                  bodyText2: TextStyle(fontSize: 16),
                ),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (_, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Scaffold(
                              body: Center(child: CircularProgressIndicator()))
                          : AuthScreen(),
                ),
          routes: {
            '/auth': (ctx) => AuthScreen(),
            '/product_detail': (ctx) => ProductDetailScreen(),
            '/cart': (ctx) => CartScreen(),
            '/orders': (ctx) => OrdersScreen(),
            '/user_products': (ctx) => UserProductsScreen(),
            '/edit_product': (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
