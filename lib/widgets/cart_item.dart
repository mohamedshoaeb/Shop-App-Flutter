import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.title, this.quantity, this.price, this.id, this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Are You Sure ?'),
            content: Text(
              'Do you want to remove this item from the cart ?',
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 25,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(child: Text('${price}')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total :  \$${price * quantity}'),
            trailing: Text('${quantity} x'),
          ),
        ),
      ),
    );
  }
}
