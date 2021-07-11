import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem({this.imageUrl, this.title, this.id});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routName, arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () =>
                  product.toggleFavoriteStatus(auth.token, auth.userId),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart_outlined,
                color: Theme.of(context).accentColor),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              print(cart.items[product.id].quantity);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item add to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
