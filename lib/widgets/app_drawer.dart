import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
                Icons.shop
            ),
            title: Text('Shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment
            ),
            title: Text('Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
              //Navigator.of(context).pushReplacement(CustomRoute(builder: (context) => OrderScreen(),),);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
                Icons.edit
            ),
            title: Text('Mange Product'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProductScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
                Icons.exit_to_app
            ),
            title: Text('Logout'),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context , listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
