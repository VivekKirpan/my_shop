import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';

class OrderItemWidget extends StatefulWidget {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItemWidget({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height:
              _isExpanded ? min(widget.products.length * 20.0 + 50, 80) : 75,
          child: ListTile(
            title: Text(
              '₹${widget.amount}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: _isExpanded ? min(widget.products.length * 20.0 + 10, 80) : 0,
          child: ListView(
            children: widget.products.map((product) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.title),
                  Text('${product.quantity}x  ₹${product.price}'),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
