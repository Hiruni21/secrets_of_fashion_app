import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, String> product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isAllOk = false;
  String selectedSize = 'M';
  String selectedColor = 'Rose Gold';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name']!)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(widget.product['image']!, height: 300),
            const SizedBox(height: 20),
            Text(widget.product['price']!, style: const TextStyle(fontSize: 24, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
            
            // Options: Size and Color
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: selectedSize,
                  items: <String>['S', 'M', 'L', 'XL'].map((String value) => DropdownMenuItem(value: value, child: Text("Size: $value"))).toList(),
                  onChanged: (val) => setState(() => selectedSize = val!),
                ),
                DropdownButton<String>(
                  value: selectedColor,
                  items: <String>['Hot Pink', 'Rose Gold', 'Black'].map((String value) => DropdownMenuItem(value: value, child: Text("Color: $value"))).toList(),
                  onChanged: (val) => setState(() => selectedColor = val!),
                ),
              ],
            ),

            const TextField(decoration: InputDecoration(labelText: "Delivery Address", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const Text("Delivery cost depends on the distance", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),

            CheckboxListTile(
              title: const Text("Everything is correct. All OK!"),
              value: isAllOk,
              onChanged: (val) => setState(() => isAllOk = val!),
              activeColor: const Color(0xFFFF1493),
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAllOk ? () {} : null, // All OK නම් පමණක් වැඩ කරයි
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    child: const Text("ADD TO CART"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAllOk ? () {} : null,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF1493)),
                    child: const Text("CHECKOUT"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}