import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, String>> _items = [];

  List<Map<String, String>> get items => _items;

  void addToCart(Map<String, String> product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      String priceString = item['price']!.replaceAll('LKR ', '').replaceAll(',', '');
      total += double.parse(priceString);
    }
    return total;
  }
}