import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';
import '../widgets/dialog_box.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String _title = '', _description = '', _imageUrl = '';
  String _productId;
  double _price;
  Product _existingProduct;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _productId = ModalRoute.of(context).settings.arguments as String;
      if (_productId != null) {
        _existingProduct = Provider.of<Products>(
          context,
          listen: false,
        ).findById(_productId);
        _title = _existingProduct.title;
        _price = _existingProduct.price;
        _description = _existingProduct.description;
        _imageUrlController.text = _existingProduct.imageUrl;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlController.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_productId != null) {
        await _existingProduct.updateProduct(
          title: _title,
          description: _description,
          imageUrl: _imageUrl,
          price: _price,
        );
      } else {
        Product newProduct = Product(
          id: DateTime.now().toString(),
          title: _title,
          price: _price,
          imageUrl: _imageUrl,
          description: _description,
          authToken: null,
        );
        await Provider.of<Products>(context, listen: false)
            .addProduct(newProduct);
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (_) => DialogBox(context: context),
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Form(
                key: _form,
                child: Column(children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) return 'Please provide a title';
                      return null;
                    },
                    onSaved: (value) {
                      _title = value;
                    },
                  ),
                  TextFormField(
                    initialValue: _price == null ? '' : _price.toString(),
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a price';
                      if (double.tryParse(value) == null)
                        return 'Please enter a number';
                      if (double.parse(value) <= 0)
                        return 'Please enter number greater than 0';
                      return null;
                    },
                    onSaved: (value) {
                      _price = double.parse(value);
                    },
                  ),
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a description';
                      return null;
                    },
                    onSaved: (value) {
                      _description = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    controller: _imageUrlController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a image URL';
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      setState(() {});
                    },
                    onSaved: (value) {
                      _imageUrl = value;
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text('Image Preview'),
                  Container(
                    height: 250,
                    width: 250,
                    margin: const EdgeInsets.all(15),
                    child: _imageUrlController.text.isEmpty
                        ? Container()
                        : Image.network(_imageUrlController.text,
                            fit: BoxFit.contain),
                  ),
                  RaisedButton(
                    child: Text('Submit'),
                    color: Theme.of(context).accentColor,
                    onPressed: _submit,
                  ),
                ]),
              ),
            ),
    );
  }
}
