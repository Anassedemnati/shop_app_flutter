import 'dart:convert';
import 'package:flutter/foundation.dart';
import './product.dart';
import 'package:http/http.dart' as http;


class Products with ChangeNotifier {
  static const productsUrl = 'https://ecomerceapp-4f8f8-default-rtdb.europe-west1.firebasedatabase.app/products.json';

  // ignore: prefer_final_fields
  List<Product> _items = [
  ];
  
  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(productsUrl));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      
      if (extractedData == null) {
        return;
      }
      
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'].toDouble(),
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'] ?? false,
        ));
      });
      
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching products: $error');
      }
      rethrow;
    }
  }
  void addProduct(Product value) {
    http.post(Uri.parse(productsUrl), body: json.encode( // post request to the firebase database products collection
      {
        'title': value.title,
        'description': value.description,
        'imageUrl': value.imageUrl,
        'price': value.price,
        'isFavorite': value.isFavorite,
      }
    )).then((response){ // then execute this code after the post request is done 
      if (kDebugMode) {
        print(json.decode(response.body));
      }
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: value.title,
        description: value.description,
        price: value.price,
        imageUrl: value.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error){ // catch error
      if (kDebugMode) { // only in development mode
        print(error); 
      }
      throw error;
    });
   
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  void updateProduct(String id, Product editedProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = editedProduct;
      notifyListeners();
    } 
  }

  




  
}