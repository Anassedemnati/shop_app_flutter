
import 'package:flutter/material.dart';

class Product  with ChangeNotifier // changeNotifier is for state management
{
    final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners(); // this will notify all the listeners that are listening to this product
  }
}