import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    @required this.description,
    @required this.id,
    this.isFavorite = false,
  });


  void _setFavoriteValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken , String userId) async {
    final bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shopapp-e7685-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode( isFavorite),
      );
      if(response.statusCode >= 400){
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }
}
