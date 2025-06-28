// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:food_in_flutter/utils/3_custom_colors.dart'; // Import AppColors

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'item': 'Burger',
      'restaurant': 'Burger King',
      'price': 250.00,
      'quantity': 2,
      'image': 'assets/flutter_img/burger.jpeg'
    },
    {
      'item': 'Pizza',
      'restaurant': 'Pizza Hut',
      'price': 650.00,
      'quantity': 1,
      'image': 'assets/flutter_img/pizza.jpeg'
    },
    {
      'item': 'Sushi',
      'restaurant': 'Sushi House',
      'price': 1200.00,
      'quantity': 1,
      'image': 'assets/flutter_img/sushi.jpeg'
    }
  ];

  double get _totalAmount {
    return _cartItems.fold(0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _placeOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.bgColor, // Set background color
          appBar: AppBar(
            title: const Text('Order Confirmed'),
            backgroundColor: AppColors.selectionColor, // Set app bar color
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 20),
                const Text(
                  'Your order has been placed!',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total: ৳${_totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor, // Set background color
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppColors.selectionColor, // Set app bar color
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Card(
                  color: AppColors.cardBackground, // Set card background
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2, // Add shadow
                  child: ListTile(
                    leading: Image.asset(
                      item['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['item']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['restaurant']),
                        Text('৳${item['price']} x ${item['quantity']} = ৳${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(index),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground, // Set container background
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('৳${_totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _placeOrder,
                  child: const Text('Place Order',
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}