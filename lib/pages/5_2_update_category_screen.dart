// lib/screens/category_screen.dart

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_in_flutter/pages/4_4_food_details.dart';
import 'package:food_in_flutter/pages/5_1_restaurant_menu.dart';
import 'package:food_in_flutter/utils/1_restaurant_list.dart';
import 'package:food_in_flutter/utils/2_category_food_imgs.dart';
import 'package:food_in_flutter/utils/3_custom_colors.dart';// Import AppColors

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> _foodItemsForCategory = [];
  late Timer timer;
  List<Map<String, String>> restaurants = [];
  final ScrollController _imgController = ScrollController();
  static const double itemSize = 150;

  @override
  void initState() {
    super.initState();
    pickRandomRestaurants();
    loadFoodItemsForCategory();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_imgController.hasClients && _foodItemsForCategory.isNotEmpty) {
        final current = _imgController.offset;
        double next = current + itemSize;
        _imgController.animateTo(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Loads 10 food items for this category with details
  void loadFoodItemsForCategory() {
    final paths = CategoryImages.getRandomImages(widget.category, count: 10);
    final foodNames = [
      'Special ${widget.category}',
      'Premium ${widget.category}',
      'Classic ${widget.category}',
      'Deluxe ${widget.category}',
      'Gourmet ${widget.category}',
      'Signature ${widget.category}',
      'Traditional ${widget.category}',
      'Authentic ${widget.category}',
      'Modern ${widget.category}',
      'Chef\'s Special ${widget.category}'
    ];

    final descriptions = [
      'Made with fresh ingredients and authentic recipe',
      'House specialty prepared with love and care',
      'Classic preparation with traditional flavors',
      'Premium quality with exquisite taste',
      'Gourmet experience with finest ingredients',
      'Signature dish with unique flavors',
      'Traditional recipe passed through generations',
      'Authentic taste with modern presentation',
      'Contemporary twist on a classic dish',
      'Chef\'s special creation with premium ingredients'
    ];

    setState(() {
      _foodItemsForCategory = List.generate(10, (index) {
        return {
          'item': foodNames[index],
          'restaurant': 'Restaurant ${index % 5 + 1}',
          'image': paths[index],
          'price': (300 + Random().nextInt(700)).toDouble(),
          'description': descriptions[index],
        };
      });
    });
  }

  void pickRandomRestaurants() {
    final rnd = Random();
    final all = SylhetRestaurantList().restaurants;
    all.shuffle(rnd);
    restaurants = all.take(5).toList();
  }

  @override
  void dispose() {
    timer.cancel();
    _imgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor, // Set background color
      appBar: AppBar(
        title: Text('${widget.category} Classics'),
        backgroundColor: AppColors.selectionColor, // Set app bar color
      ),
      body: Container(
        color: AppColors.bgColor, // Set container background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Top 10 ${widget.category} Picks Near You',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: itemSize,
              child: _foodItemsForCategory.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                controller: _imgController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  final foodItem = _foodItemsForCategory[index % _foodItemsForCategory.length];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailScreen(foodItem: foodItem),
                        ),
                      );
                    },
                    child: Container(
                      width: itemSize,
                      height: itemSize,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(foodItem['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodItem['item'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '৳${foodItem['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Popular Restaurants for ${widget.category}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: restaurants.length,
                itemBuilder: (ctx, i) {
                  final rest = restaurants[i];
                  final rating =
                  (4.0 + Random().nextDouble()).toStringAsFixed(1);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantMenuScreen(
                            restaurant: rest,
                            category: widget.category,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.antiAlias,
                      color: AppColors.cardBackground, // Set card background
                      elevation: 2, // Add subtle shadow
                      child: Row(
                        children: [
                          Image.asset(
                            rest['image']!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rest['name']!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Rating: $rating'),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap to view ${widget.category} menu',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}