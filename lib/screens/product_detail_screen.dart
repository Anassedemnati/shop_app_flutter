import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context)?.settings.arguments as String; // is the id!

    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    final cart = Provider.of<Cart>(context, listen: false);

    final productAlreadyInCart = cart.items.containsKey(loadedProduct.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            //add button to add to cart here

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 30),
              child: ElevatedButton(
                onPressed: productAlreadyInCart
                    ? null
                    : () {
                        cart.addItem(loadedProduct.id, loadedProduct.price,
                            loadedProduct.title);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added item to cart!',
                            ),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                //remove item from cart
                                cart.removeSingleItem(loadedProduct.id);
                              },
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: productAlreadyInCart
                      ? Colors.grey
                      : Theme.of(context).colorScheme.secondary,
                  alignment: Alignment.center,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.shopping_cart, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      productAlreadyInCart ? 'In Cart' : 'Add to Cart',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
