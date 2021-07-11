import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products_Provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routName = '/UserProductScreen';

  Future<void> refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProducScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: refreshProduct(context),
        builder: (context, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => refreshProduct(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItem(
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imageUrl,
                                id: productsData.items[index].id,
                              ),
                              Divider(
                                height: 40,
                              ),
                            ],
                          ),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
