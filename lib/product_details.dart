import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, String> product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String deliveryCost = "";
  String selectedSize = "";
  Color? selectedColor; // තෝරාගත් පාට තබා ගැනීමට
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isShoes = widget.product['type']?.toLowerCase().contains('shoe') ?? false;
    List<String> sizeList = isShoes 
        ? ['5', '6', '7', '8', '9', '10'] 
        : ['S', 'M', 'L', 'XL'];

    return Scaffold(
      appBar: AppBar(title: const Text("Product Details"), backgroundColor: const Color(0xFFD4AF37)),
      body: SingleChildScrollView(
        child: Column(
          children: [
           Container(
  height: 150,
  width: double.infinity,
  child: Image.asset(
    widget.product['image']!, 
    fit: BoxFit.contain,
    filterQuality: FilterQuality.high, // මෙතනටත් එකතු කරන්න
  ),
),
            
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product['name']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(widget.product['price']!, style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // --- COLOR SELECTION ---
                  const Text("Select Color:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _colorOption(Colors.black),
                      _colorOption(Colors.red),
                      _colorOption(Colors.blue),
                      _colorOption(const Color(0xFFFFC0CB)), // Pink
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- SIZE SELECTION ---
                  const Text("Select Size:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    children: sizeList.map((size) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(size),
                          selected: selectedSize == size,
                          selectedColor: const Color(0xFFFF1493),
                          labelStyle: TextStyle(color: selectedSize == size ? Colors.white : Colors.black),
                          onSelected: (bool selected) {
                            setState(() { selectedSize = size; });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: "Delivery Address",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        if (value.isNotEmpty) deliveryCost = "Delivery Cost: LKR 350.00";
                      });
                    },
                  ),
                  
                  if (deliveryCost.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(deliveryCost, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    ),
                  
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF1493)),
                      onPressed: () {
                        if (selectedColor == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a color!")));
                          return;
                        }
                        if (selectedSize.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a size!")));
                          return;
                        }
                        Provider.of<CartProvider>(context, listen: false).addToCart(widget.product);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to Cart Successfully!")));
                      },
                      child: const Text("ADD TO CART", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorOption(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() { selectedColor = color; });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF1493) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: color,
        ),
      ),
    );
  }
}