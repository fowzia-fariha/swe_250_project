// lib/screens/category_screen.dart

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_in_flutter/utils/1_restaurant_list.dart';
import 'package:food_in_flutter/utils/2_category_food_imgs.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<ImageProvider> imageAssets = [];
  late Timer timer;
  List<Map<String, String>> restaurants = [];
  final ScrollController _imgController = ScrollController();
  static const double itemSize = 150;

  @override
  void initState() {
    super.initState();
    pickRandomRestaurants();
    loadImagesForCategory();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_imgController.hasClients && imageAssets.isNotEmpty) {
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

  /// Loads 10 random images for this category using CategoryImages helper.
  void loadImagesForCategory() {
    final paths = CategoryImages.getRandomImages(widget.category, count: 10);
    setState(() {
      imageAssets = paths.map((p) => AssetImage(p)).toList();
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
    const bgColor = Color(0xFFFFE0B2);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('${widget.category} Classics'),
        backgroundColor: bgColor,
      ),
      body: Container(
        color: bgColor,
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
              child: imageAssets.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                controller: _imgController,
                scrollDirection: Axis.horizontal,
                // infinite looping
                itemBuilder: (ctx, index) {
                  final img = imageAssets[index % imageAssets.length];
                  return Container(
                    width: itemSize,
                    height: itemSize,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: img,
                        fit: BoxFit.cover,
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
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.antiAlias,
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
                              ],
                            ),
                          ),
                        ),
                      ],
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
