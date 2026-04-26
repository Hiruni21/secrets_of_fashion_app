import 'package:flutter/material.dart';
import 'product_list_page.dart';

class CategoryPage extends StatelessWidget {
  final String mainCategory;
  CategoryPage({super.key, required this.mainCategory});

  final Map<String, List<Map<String, dynamic>>> subCategories = {
    "Fashion for Womens": [
      {"name": "Blouses", "prefix": "B", "count": 20},
      {"name": "Frocks", "prefix": "F", "count": 40},
      {"name": "Skirts", "prefix": "S", "count": 36},
      {"name": "Office Pants", "prefix": "O", "count": 20},
      {"name": "Denim Clothes", "prefix": "D", "count": 27},
      {"name": "Crop Tops", "prefix": "C", "count": 21},
      {"name": "Cargo Pants", "prefix": "K", "count": 13},
    ],
    "Fashion for Mens": [
      {"name": "Shirts", "prefix": "S", "count": 27},
      {"name": "Trousers", "prefix": "R", "count": 35},
      {"name": "Denims", "prefix": "D", "count": 15},
      {"name": "T-shirts", "prefix": "T", "count": 21},
    ],
    "Fashion for Shoes": [
      {"name": "Heels", "prefix": "H", "count": 25},
      {"name": "Stands", "prefix": "S", "count": 30},
      {"name": "Sneakers", "prefix": "SN", "count": 31},
      {"name": "Office Shoes", "prefix": "O", "count": 23},
    ],
    "Fashion for Bags": [
      {"name": "Hand Bag", "prefix": "HB", "count": 28},
      {"name": "Backpack", "prefix": "B", "count": 30},
      {"name": "Clutches", "prefix": "C", "count": 20},
      {"name": "Wallets", "prefix": "W", "count": 25},
    ],
    "Fashion for Kids": [
      {"name": "Baby Girl Clothes", "prefix": "BG", "count": 60},
      {"name": "Baby Boy Clothes", "prefix": "BB", "count": 46},
      {"name": "Toys", "prefix": "T", "count": 25},
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = subCategories[mainCategory] ?? [];
    String folder = mainCategory.split(' ').last; // e.g., Womens, Mens

    return Scaffold(
      appBar: AppBar(
        title: Text(mainCategory, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20, childAspectRatio: 0.8
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListPage(
              categoryName: items[index]['name'],
              prefix: items[index]['prefix'],
              count: items[index]['count'],
              folder: folder,
            ))),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFE5B18A)])),
                  child: CircleAvatar(
                    radius: 55, backgroundColor: Colors.white,
                    child: Text(items[index]['prefix'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
                  ),
                ),
                const SizedBox(height: 10),
                Text(items[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}