import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'checkout_screen.dart'; // Checkout screen එක අනිවාර්යයෙන් import කරන්න

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);

    // Calculation කොටස
    double itemTotal = cart.totalPrice; // Cart එකේ ඇති බඩු වල එකතුව
    double deliveryFee = 350.0; // ස්ථාවර Delivery ගාස්තුව
    double finalTotal = itemTotal + deliveryFee; // සම්පූර්ණ එකතුව

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: const Color(0xFFFF1493),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(cart.items[index]['image']!),
                        title: Text(cart.items[index]['name']!),
                        subtitle: Text(cart.items[index]['price']!),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => cart.removeItem(index),
                        ),
                      );
                    },
                  ),
                ),
                
                // Total එක පෙන්වන කොටස
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Item Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Item Total:"),
                          Text("LKR ${itemTotal.toStringAsFixed(2)}"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Delivery Fee
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Delivery Fee:"),
                          Text("LKR ${deliveryFee.toStringAsFixed(2)}"),
                        ],
                      ),
                      const Divider(thickness: 1),
                      
                      // Final Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Grand Total:",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "LKR ${finalTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xFFFF1493),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Updated Checkout Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF1493), // Hot Pink color
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                cartItems: cart.items, // Provider එකෙන් items ලබා ගැනීම
                                total: finalTotal,      // Delivery fee එකත් එක්ක එන සම්පූර්ණ එකතුව
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "PROCEED TO CHECKOUT",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}