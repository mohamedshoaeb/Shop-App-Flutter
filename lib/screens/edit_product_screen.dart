import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products_Provider.dart';
import 'package:shop_app/providers/product.dart';

class EditProducScreen extends StatefulWidget {
  static const routeName = '/editeproduct';

  @override
  _EditProducScreenState createState() => _EditProducScreenState();
}

class _EditProducScreenState extends State<EditProducScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String productId;
  var _isInit = true;
  var _isLoading = false;
  var _editedProduct =
      Product(title: '', imageUrl: '', price: 0, description: '', id: null);
  var _initValues = {
    'title': '',
    'imageUrl': '',
    'price': '',
    'description': ''
  };

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'imageUrl': _editedProduct.imageUrl,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description
        };
        _imageUrlController.text = _initValues['imageUrl'];
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  Future<void> _saveForm() async{
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (productId == null) {
      try{
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      }
      catch(error) {
        await showDialog(context: context, builder: (ctx) =>
            AlertDialog(
              title: Text('An erorr occurred!'),
              content: Text('Something went wrong!!!'),
              actions: [
                FlatButton(onPressed: () {
                  Navigator.of(ctx).pop();
                }, child: Text('Okay'))
              ],
            ));
      }
      // finally{
      //   setState(() {
      //     _isLoading = false;
      //     Navigator.of(context).pop();
      //   });
      // }
    }
    else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Product Title'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Title of Product';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Product Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Price of Product';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please Enter a Valid Number';
                        }
                        if (double.parse(value) <= 2) {
                          return 'Please Enter a Valid Price (Price must greater than 2\$)';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration:
                          InputDecoration(labelText: 'Product Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            description: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Price of Description';
                        }
                        if (value.length < 10) {
                          return 'Should be at lest 10 characters long.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                      _imageUrlController.text.toString()),
                                  fit: BoxFit.contain,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              if (_imageUrlController.text.isEmpty ||
                                  (!_imageUrlController.text
                                          .startsWith('http') &&
                                      !_imageUrlController.text
                                          .startsWith('https')) ||
                                  (!_imageUrlController.text.endsWith('.jpg') &&
                                      !_imageUrlController.text
                                          .endsWith('.png') &&
                                      !_imageUrlController.text
                                          .endsWith('.jpeg'))) {
                                return;
                              }
                              setState(() {
                                _imageUrlController.text;
                              });
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  title: _editedProduct.title,
                                  imageUrl: value,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter an image URL ';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please Enter a valid URL';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please Enter a valid URL';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
