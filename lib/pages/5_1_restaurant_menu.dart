// lib/screens/restaurant_menu_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_in_flutter/pages/4_4_food_details.dart';
import 'package:food_in_flutter/utils/2_category_food_imgs.dart';
import 'package:food_in_flutter/utils/3_custom_colors.dart'; // Import AppColors

class RestaurantMenuScreen extends StatelessWidget {
  final Map<String, String> restaurant;
  final String category;

  const RestaurantMenuScreen({Key? key, required this.restaurant, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate 5-6 menu items for this restaurant and category
    final menuItems = List.generate(5 + Random().nextInt(2), (index) {
      final foodNames = [
        'Special $category Dish',
        'Premium $category',
        'Classic $category',
        'Signature $category',
        'Deluxe $category',
        'Gourmet $category'
      ];

      final descriptions = [
        'Authentic recipe with fresh ingredients',
        'House specialty made with love',
        'Chef\'s recommended dish',
        'Best seller with premium ingredients',
        'Traditional preparation with modern twist'
      ];

      return {
        'item': '${restaurant['name']} ${foodNames[index % foodNames.length]}',
        'restaurant': restaurant['name']!,
        'image': CategoryImages.getRandomImages(category, count: 1)[0],
        'price': (500 + Random().nextInt(1000)).toDouble(),
        'description': descriptions[index % descriptions.length],
      };
    });

    return Scaffold(
      backgroundColor: AppColors.bgColor, // Set background color
      appBar: AppBar(
        title: Text('${restaurant['name']} - $category Menu'),
        backgroundColor: AppColors.selectionColor, // Set app bar color
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          // Explicitly cast price to double
          final price = item['price'] as double;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.cardBackground, // Set card background
            elevation: 2, // Add subtle shadow
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Image.asset(
                item['image'] as String, // Cast to String
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                item['item'] as String, // Cast to String
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '৳${price.toStringAsFixed(2)}', // Use the casted price
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] as String, // Cast to String
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailScreen(foodItem: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}