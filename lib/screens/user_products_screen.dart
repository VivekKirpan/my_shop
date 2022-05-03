import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_products_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts(filterByCreator: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit_product');
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: refreshProducts(context),
          builder: (_, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => refreshProducts(context),
                  child: Consumer<Products>(builder: (_, productData, __) {
                    final products = productData.products;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, i) => ChangeNotifierProvider.value(
                        value: products[i],
                        child: UserProductsItem(),
                      ),
                      padding: const EdgeInsets.all(10),
                    );
                  }),
                )),
    );
  }
}
