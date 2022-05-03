import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItemWidget(
      {this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.deleteItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        padding: const EdgeInsets.only(right: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: const Icon(Icons.delete, size: 40),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: ListTile(
          leading: CircleAvatar(child: FittedBox(child: Text('₹$price'))),
          title: Text(title),
          subtitle: Text('Subtotal: ₹${price * quantity}'),
          trailing: FittedBox(
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  cart.decrementQuantity(productId);
                },
              ),
              Text('$quantity'),
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    cart.incrementQuantity(productId);
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
