import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final scaffold = Scaffold.of(context);

    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            '/product_detail',
            arguments: product.id,
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/no-image.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
          leading: Consumer<Product>(
            builder: (_, product, __) => IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
              onPressed: () async {
                try {
                  await product.toggleFavourite(auth.userId);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content:
                        Text(error.toString(), textAlign: TextAlign.center),
                  ));
                }
              },
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            color: Theme.of(context).primaryColorLight,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              scaffold.hideCurrentSnackBar();
              scaffold.showSnackBar(SnackBar(
                content: const Text('Item added to cart'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () => cart.decrementQuantity(product.id),
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
