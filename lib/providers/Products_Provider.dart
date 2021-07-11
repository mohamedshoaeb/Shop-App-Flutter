import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/Products_Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/product.dart';
import 'package:provider/provider.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;
  Products(this.authToken,this.userId , this._items);

  List<Product> get favoritesItem {
    return _items.where((element) => element.isFavorite).toList();
  }


  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp-e7685-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId' :userId
        }),
      );
      final newProduct = Product(
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        description: product.description,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // or _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    ;
  }

  void updateProduct(String productId, Product newProduct)async {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);

    try{
      if (productIndex >= 0) {
        final url =
            'https://shopapp-e7685-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
        await http.patch(Uri.parse(url) , body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }));
        _items[productIndex] = newProduct;
        notifyListeners();
      } else {
        print('NO Product found to update');
      }
    }
   catch(error){
      throw error;
   }
  }

  Future<void> deleteItem(String productId) async{
    final url =
        'https://shopapp-e7685-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((element) => element.id == productId);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == productId);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    print(response.statusCode);
    if(response.statusCode >= 400){
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Coud not delet');
    }
    existingProduct =null;


  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final String filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopapp-e7685-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extactedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if (extactedData == null) {
        return;
      }
      url =
      'https://shopapp-e7685-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoritesResponse = await http.get(Uri.parse(url));
      final favoritesData = jsonDecode(favoritesResponse.body);
      extactedData.forEach((productId, productData) {
        loadedProduct.add(Product(
          title: productData['title'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          description: productData['description'],
          id: productId,
          isFavorite: favoritesData == null ? false :favoritesData[productId] ?? false,
        ));
      });
      _items = loadedProduct;
      notifyListeners();

    } catch (error) {
      throw error;
    }

  }
// var _showFavoritesOnly = false;
  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
}
