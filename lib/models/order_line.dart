
import 'package:flutter_complete_guide/models/cart_line.dart';

class OrderLine {
  final String id;
  final double amount;
  final List<CartLine> products;
  final DateTime dateTime;

  OrderLine({
      required this.id,
      required this.amount,
      required this.products,
      required this.dateTime,
  });
}

