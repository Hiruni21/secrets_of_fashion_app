import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final List<dynamic> cartItems;
  final double total;

  const CheckoutScreen({super.key, required this.cartItems, required this.total});

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), backgroundColor: const Color(0xFFFF1493)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Total Amount: Rs. $total", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "Delivery Address")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance.collection('orders').add({
                  'userId': user?.uid,
                  'items': cartItems,
                  'total': total,
                  'address': addressController.text,
                  'date': Timestamp.now(),
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order Placed Successfully!")));
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Place Order"),
            )
          ],
        ),
      ),
    );
  }
}