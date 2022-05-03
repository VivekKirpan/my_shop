import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/dialog_box.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartItems,
    @required this.cart,
  }) : super(key: key);

  final List<CartItem> cartItems;
  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  Future<void> order(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Orders>(
        context,
        listen: false,
      ).addOrder(widget.cartItems, widget.cart.totalAmount);
      widget.cart.clear();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (_) => DialogBox(context: context),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : RaisedButton(
            elevation: 5,
            color: Theme.of(context).accentColor,
            child: Text('Place Order', style: TextStyle(fontSize: 18)),
            onPressed: widget.cart.itemCount == 0
                ? null
                : () {
                    order(context);
                  },
          );
  }
}
