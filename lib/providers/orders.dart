import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders extends ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Orders(this.authToken ,this.userId ,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url = 'https://shopapp-e7685-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final executedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> dataBaseOrders = [];
      if (executedData == null) {
        return;
      }
      executedData.forEach((ordeId, order) {
        dataBaseOrders.add(OrderItem(
          id: ordeId,
          amount: order['amount'],
          dateTime: DateTime.parse(order['dateTime']),
          products: (order['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
        ));
      });
      _orders = dataBaseOrders.reversed.toList();
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shopapp-e7685-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    var timestamp = DateTime.now();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }),
      );
      _orders.add(OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts));
      notifyListeners();
    } catch (error) {}
  }
}
