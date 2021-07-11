import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ?  min(widget.order.products.length * 20.0 + 120, 300) : 130,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '\$${widget.order.amount}',
              ),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy   hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),

              AnimatedContainer(
                duration: Duration(milliseconds: 300),

                padding: EdgeInsets.symmetric(vertical: 5 , horizontal: 15),
                height:_expanded? min(widget.order.products.length * 20.0 + 10, 100) : 0,
                child: ListView(
                  children: widget.order.products
                      .map((product) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${product.quantity} x \$${product.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ))
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
