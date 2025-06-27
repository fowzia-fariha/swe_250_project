/// lib/utils/category_images.dart
///
/// A utility class mapping user-facing category names
/// to their full list of bundled asset image paths.
/// Provides a method to randomly select a subset of images for display.

import 'dart:math';

class CategoryImages {
  /// Full lists of images for each category.
  /// Keys match the exact user-facing category names.
  static final Map<String, List<String>> _images = {
    'Fast Food': [ for (var i = 1; i <= 15; i++) 'assets/flutter_img/Fast Food/$i.jpeg', ],
    'Healthy': [ for (var i = 1; i <= 15; i++) 'assets/flutter_img/healthy/$i.jpeg', ],
    'Vegan': [ for (var i = 1; i <= 7; i++) 'assets/flutter_img/vegan/$i.jpeg', ],
    'Desserts': [ for (var i = 1; i <= 15; i++) 'assets/flutter_img/desserts/$i.jpeg', ],
    'Drinks': [
      for (var i = 1; i <= 10; i++) 'assets/flutter_img/Drinks/$i.jpeg',
    ],
    'Snacks': [ for (var i = 1; i <= 11; i++) 'assets/flutter_img/snacks/$i.jpeg', ],
    'Breakfast': [ for (var i = 1; i <= 15; i++) 'assets/flutter_img/breakfast/$i.jpeg', ],
  };

  /// Returns up to [count] random images for the given exactly matched [category].
  static List<String> getRandomImages(String category, {int count = 10}) {
    final all = _images[category] ?? [];
    if (all.isEmpty) return [];
    final shuffled = List<String>.from(all)..shuffle(Random());
    return shuffled.take(count).toList();
  }
}

