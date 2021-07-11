import 'package:flutter/material.dart';
import 'package:shop_app/providers/Products_Provider.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGraid extends StatelessWidget {
  final bool showFavorites;
  ProductGraid({this.showFavorites});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    final products = showFavorites ? productsData.favoritesItem : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
              value:products[i],
              child: ProductItem(
                  // id: products[i].id,
                  // imageUrl: products[i].imageUrl,
                  // title: products[i].title,
                  ),
            ));
  }
}
