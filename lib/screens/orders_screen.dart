import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item_widget.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snapshot.hasError)
            return Center(child: const Text('An Error Occurred'));
          else {
            return Consumer<Orders>(builder: (context, ordersData, _) {
              List<OrderItem> orders = ordersData.orders;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, i) => Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  child: OrderItemWidget(
                    id: orders[i].id,
                    amount: orders[i].amount,
                    dateTime: orders[i].dateTime,
                    products: orders[i].products,
                  ),
                ),
              );
            });
          }
        },
      ),
    );
  }
}
