import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../widgets/cart_icon.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          Consumer<Cart>(
              builder: (_, cart, __) => CartIcon(cart.itemCount.toString())),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            constraints: BoxConstraints(maxHeight: 400),
            margin: const EdgeInsets.all(10),
            child: Hero(
              tag: product.id,
              child: Image.network(product.imageUrl, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text(product.title, style: Theme.of(context).textTheme.headline6),
              Divider(),
              Text(
                'Price: ₹${product.price}',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Divider(),
              Text(product.description),
            ]),
          ),
          RaisedButton(
            child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
            color: Theme.of(context).accentColor,
            onPressed: () => cart.addItem(
              productId,
              product.title,
              product.price,
            ),
          ),
        ]),
      ),
    );
  }
}
