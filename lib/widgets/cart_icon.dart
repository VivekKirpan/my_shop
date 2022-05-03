import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  final String itemCount;

  CartIcon(this.itemCount);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(minHeight: 18, minWidth: 18),
            child: Text(
              itemCount,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
