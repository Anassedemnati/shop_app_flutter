import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/user.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/login_screen.dart';
import 'package:flutter_complete_guide/screens/product_form_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:flutter_complete_guide/screens/user_profile_screen.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';

import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider is used to provide multiple providers at the same time in the app 
    return MultiProvider(
        providers: [
           ChangeNotifierProvider.value(
            value: Auth(), // this is the provider for the auth
          ),
          ChangeNotifierProxyProvider<Auth, Products>( //injecting the auth provider into the products provider
            create: (_) => Products('', []),
            update: (_, auth, previousProducts) => Products(
              auth.token ?? '',
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Orders(),
          ),
          ChangeNotifierProvider.value(
            value: UserProvider(), // this is the provider for the user
          ),
         
        

        ],
        child: Consumer<Auth>( // injecting the auth provider into the app 
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth // check if the user is authenticated
                ? ProductsOverviewScreen()
                :  AuthScreen(), // this is the screen that will be shown when the user is not authenticated

            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              ProductFormScreen.routeName: (ctx) => ProductFormScreen(),
              UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(), // this is the route for the login screen
              ProductsOverviewScreen.routeName: (ctx) =>ProductsOverviewScreen(), // this is the route for the products overview screen

            })));
  }
}
