
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products_Provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:shop_app/widgets/product_graid.dart';

enum FilterOption {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}


class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnleFavorites = false;
  var _initState = true;
  var _isLoaded = false;

  @override
  void initState() {
      //Provider.of<Products>(context).fetchAndSetProducts(); //مش هتشتغل كدة لازم تطحط فى Future
      // Future.delayed(Duration.zero).then((_) => (){
      //   Provider.of<Products>(context).fetchAndSetProducts();
      // });
      super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_initState){
      _isLoaded = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        _isLoaded =false;
      });

    }
    _initState =false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption valu) {
              setState(() {
                if (valu == FilterOption.Favorites) {
                  _showOnleFavorites = true;
                } else {
                  _showOnleFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOption.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, catrData, ch) => Badge(
              child: ch,
              value: catrData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoaded ? Center(
        child: CircularProgressIndicator(),
      ):ProductGraid(showFavorites: _showOnleFavorites),
    );
  }
}
