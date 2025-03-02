import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/user.dart';
import 'package:flutter_complete_guide/screens/login_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:flutter_complete_guide/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(userProvider.user != null ? 'Hello ${userProvider.user!.userName}' : 'Hello User'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(userProvider.user != null ? 'Profile' : 'Login'),
            onTap: () {
              if (userProvider.user != null) {
                Navigator.of(context)
                    .pushReplacementNamed(UserProfileScreen.routeName);
              } else {
                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }
}
