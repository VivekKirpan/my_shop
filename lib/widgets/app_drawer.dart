import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: Text('Shop', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.payments),
            title: Text('Orders', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => Navigator.of(context).pushReplacementNamed('/orders'),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(
              'Manage Products',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/user_products');
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
