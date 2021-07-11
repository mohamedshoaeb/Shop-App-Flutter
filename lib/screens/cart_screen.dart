import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart-Screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      cart.totalAmont.toStringAsFixed(2),
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                title: cart.items.values.toList()[index].title,
                quantity: cart.items.values.toList()[index].quantity,
                price: cart.items.values.toList()[index].price,
                productId: cart.items.keys.toList()[index],
              ),
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : FlatButton(
            onPressed: (widget.cart.totalAmont <= 0 || _isLoading == true)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Orders>(context, listen: false)
                        .addOrder(widget.cart.items.values.toList(),
                            widget.cart.totalAmont)
                        .then((value) => {
                              setState(() {
                                _isLoading = false;
                              })
                            });

                    widget.cart.clearCart();
                  },
            child: Text('ORDER NOW'),
            textColor: Theme.of(context).primaryColor,
          );
  }
}
