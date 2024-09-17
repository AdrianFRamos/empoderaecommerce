import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Total: ${_calculateTotal()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Process payment
                _processPayment();
              },
              child: Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }

  _calculateTotal() {
    // Calculate total price of products in cart
    final cart = await DatabaseHelper.instance.getCart();
    double total = 0;
    for (Product product in cart) {
      total += product.price;
    }
    return total;
  }

  _processPayment() async {
    // Process payment
    // Update order status in database
    // Navigate to order confirmation screen
    Navigator.pushNamed(context, '/order_confirmation');
  }
}