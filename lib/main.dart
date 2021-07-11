import 'package:flutter/material.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products_Provider.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (context, auth, proviseProducts) => Products(
            auth.token,
            auth.userId,
            proviseProducts == null ? [] : proviseProducts.items,
          ),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (_, auth, ProviosOrder) => Orders(
            auth.token,
            auth.userId,
            ProviosOrder == null ? [] : ProviosOrder.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android:CustomPageTransationRoute(),
              TargetPlatform.iOS:CustomPageTransationRoute()
            }
            )
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routName: (context) => OrderScreen(),
            UserProductScreen.routName: (context) => UserProductScreen(),
            EditProducScreen.routeName: (context) => EditProducScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
          },
        );
      }),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my shop'),
      ),
      body: Center(
        child: Text('my shop'),
      ),
    );
  }
}
