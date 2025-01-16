import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/cart_line.dart';
import 'package:flutter_complete_guide/models/order_line.dart';

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  final List<OrderLine> _orders = [
    OrderLine(
      id: '1',
      amount: 59.99,
      dateTime: DateTime.now(),
      products: [
        CartLine(
          id: '1',
          title: 'Red Shirt',
          quantity: 2,
          price: 29.99,
        ),
        CartLine(
          id: '2',
          title: 'Black Pants',
          quantity: 1,
          price: 30.00,
        ),
      ],
    ),
    OrderLine(
      id: '2',
      amount: 19.99,
      dateTime: DateTime.now(),
      products: [
        CartLine(
          id: '3',
          title: 'Blue Shirt',
          quantity: 1,
          price: 19.99,
        ),
      ],
    ),
  ];


  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (ctx, i) => OrderItem(_orders[i]),
      ),
    );
  }
}
