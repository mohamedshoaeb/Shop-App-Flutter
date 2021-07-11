import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products_Provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;
  UserProductItem({this.title, this.imageUrl, this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            imageUrl,
          ),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProducScreen.routeName, arguments: id);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: ()  {
                  return showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Are You Sure ?'),
                      content: Text(
                        'Do you want to remove this item from the Store ?',
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('No'),
                        ),
                        FlatButton(
                          onPressed: () async{
                            Navigator.of(context).pop(true);
                            try {
                              await Provider.of<Products>(context, listen: false)
                                  .deleteItem(id);
                            } catch (error) {
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text('Deleting Fiald!' , textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                color: Theme.of(context).errorColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
