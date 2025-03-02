import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class ProductFormScreen extends StatefulWidget {
  static const routeName = '/product-form';

  const ProductFormScreen({super.key});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final priceFocusNode = FocusNode(); // FocusNode pour le champ de prix 
  final descriptionFocusNode = FocusNode();  // FocusNode pour le champ de description
  final imageUrlController = TextEditingController();
  final imageUrlFocusNode = FocusNode();
  final form = GlobalKey<FormState>(); // GlobalKey pour le formulaire
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {// Ajout des listeners pour les FocusNode
    imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() { // Suppression des listeners pour les FocusNode
    imageUrlFocusNode.removeListener(_updateImageUrl);
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlController.dispose();
    imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() { // Fonction pour sauvegarder le formulaire
    final isValid = form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editedProduct.id != '';

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: form,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Basic Information',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      initialValue: _initValues['title'],
                                      decoration: InputDecoration(
                                        labelText: 'Title',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        prefixIcon: const Icon(Icons.title),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(priceFocusNode);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please provide a title';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _editedProduct = Product(
                                          title: value!,
                                          price: _editedProduct.price,
                                          description:
                                              _editedProduct.description,
                                          imageUrl: _editedProduct.imageUrl,
                                          id: _editedProduct.id,
                                          isFavorite: _editedProduct.isFavorite,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      initialValue: _initValues['price'],
                                      decoration: InputDecoration(
                                        labelText: 'Price',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        prefixIcon:
                                            const Icon(Icons.attach_money),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      focusNode: priceFocusNode,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(descriptionFocusNode);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a price';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        if (double.parse(value) <= 0) {
                                          return 'Please enter a number greater than zero';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _editedProduct = Product(
                                          title: _editedProduct.title,
                                          price: double.parse(value!),
                                          description:
                                              _editedProduct.description,
                                          imageUrl: _editedProduct.imageUrl,
                                          id: _editedProduct.id,
                                          isFavorite: _editedProduct.isFavorite,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Description',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      initialValue: _initValues['description'],
                                      decoration: InputDecoration(
                                        labelText: 'Description',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignLabelWithHint: true,
                                      ),
                                      maxLines: 5,
                                      keyboardType: TextInputType.multiline,
                                      focusNode: descriptionFocusNode,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a description';
                                        }
                                        if (value.length < 10) {
                                          return 'Should be at least 10 characters long';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _editedProduct = Product(
                                          title: _editedProduct.title,
                                          price: _editedProduct.price,
                                          description: value!,
                                          imageUrl: _editedProduct.imageUrl,
                                          id: _editedProduct.id,
                                          isFavorite: _editedProduct.isFavorite,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Product Image',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          height: 100,
                                          margin: const EdgeInsets.only(
                                            top: 8,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: imageUrlController.text.isEmpty
                                              ? const Center(
                                                  child: Text(
                                                    'Enter a URL',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  child: Image.network(
                                                    imageUrlController.text,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Image URL',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              prefixIcon:
                                                  const Icon(Icons.link),
                                            ),
                                            keyboardType: TextInputType.url,
                                            textInputAction:
                                                TextInputAction.done,
                                            controller: imageUrlController,
                                            focusNode: imageUrlFocusNode,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter an image URL';
                                              }
                                              if (!value.startsWith('http') &&
                                                  !value.startsWith('https')) {
                                                return 'Please enter a valid URL';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _editedProduct = Product(
                                                title: _editedProduct.title,
                                                price: _editedProduct.price,
                                                description:
                                                    _editedProduct.description,
                                                imageUrl: value!,
                                                id: _editedProduct.id,
                                                isFavorite:
                                                    _editedProduct.isFavorite,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _saveForm,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: Text(
                            isEditing ? 'Edit Product' : 'Add Product',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
