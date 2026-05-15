import 'package:flutter/material.dart';
import '../../features/shop/models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;
  
  int get itemCount => _items.length;

  // Check if a product is already in the wishlist
  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  // Add or remove the product
  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }
}