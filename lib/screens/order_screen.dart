import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routName = '/Order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _ordersFuture;

  Future getOrders(){
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
  }
  @override
  void initState() {
    _ordersFuture = getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              _ordersFuture,
          builder: (context, snapShotData) {
            if (snapShotData.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if(snapShotData.error != null){
                return Center(child: Text('Sorry error an occurred'),);
              }
              else{
                return Consumer<Orders>(
                  builder:(context  ,orderData ,child) => ListView.builder(
                    itemBuilder: (context, index) =>
                        OrderItem(orderData.orders[index]),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
