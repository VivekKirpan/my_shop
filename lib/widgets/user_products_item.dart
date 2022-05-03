import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class UserProductsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final scaffold = Scaffold.of(context);

    return Card(
      margin: const EdgeInsets.all(7),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
        title: Text(product.title),
        trailing: FittedBox(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/edit_product',
                    arguments: product.id,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(product.id);
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                      content:
                          Text(error.toString(), textAlign: TextAlign.center),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
