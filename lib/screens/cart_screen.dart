import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item_widget.dart';
import '../widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final cartItemsKeys = cart.items.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: Theme.of(context).textTheme.headline6),
                Chip(
                  label: Text(
                    '₹${cart.totalAmount}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
        OrderButton(cartItems: cartItems, cart: cart),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (ctx, i) => CartItemWidget(
              id: cartItems[i].id,
              productId: cartItemsKeys[i],
              price: cartItems[i].price,
              quantity: cartItems[i].quantity,
              title: cartItems[i].title,
            ),
          ),
        ),
      ]),
    );
  }
}
