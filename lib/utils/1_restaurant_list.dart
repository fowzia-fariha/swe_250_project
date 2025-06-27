import 'package:flutter/material.dart';

class SylhetRestaurantList extends StatelessWidget {
  final List<Map<String, String>> restaurants = [
    {
      'name': 'The Glasshouse',
      'image': 'assets/flutter_img/res_the_glasshouse.jpeg',
      'cuisine': 'Local & Continental',
      'location': 'Grand Sultan Tea Resort & Golf',
      'details': 'Scenic riverside dining with diverse menu.'
    },
    {
      'name': 'Cafe Dreamland',
      'image': 'assets/flutter_img/res_cafe_dreamland.jpeg',
      'cuisine': 'Cafe & Snacks',
      'location': 'Nilkuthi, Sylhet',
      'details': 'Cozy coffee spot popular among youngsters.'
    },
    {
      'name': 'Mezbaan',
      'image': 'assets/flutter_img/res_mezbaan.jpeg',
      'cuisine': 'Bangladeshi',
      'location': 'Mezanine City Center',
      'details': 'Authentic Sylheti dishes in a casual setting.'
    },
    {
      'name': 'Royal Dine',
      'image': 'assets/flutter_img/res_royal_dine.jpeg',
      'cuisine': 'Asian & BBQ',
      'location': 'Zindabazar',
      'details': 'BBQ buffet and family-friendly atmosphere.'
    },
    {
      'name': 'Acropolis',
      'image': 'assets/flutter_img/res_acropolis.jpeg',
      'cuisine': 'Mediterranean',
      'location': 'Khanpur',
      'details': 'Greek-inspired menu with vegetarian options.'
    },
    {
      'name': 'Fatima’s Steakhouse',
      'image': 'assets/flutter_img/res_fatimas_steakhouse.jpeg',
      'cuisine': 'Steak & Grill',
      'location': 'Court Road',
      'details': 'Premium steaks and grilled specialties.'
    },
    {
      'name': 'Tea Hut',
      'image': 'assets/flutter_img/res_tea_hut.jpeg',
      'cuisine': 'Beverages & Light Bites',
      'location': 'Sylhet City Center',
      'details': 'Wide variety of teas and light Snacks-items.'
    },
    {
      'name': 'Salvia’s Kitchen',
      'image': 'assets/flutter_img/res_salvias_kitchen.jpeg',
      'cuisine': 'Desserts & Bakery',
      'location': 'Guwahati Point',
      'details': 'Fresh pastries, cakes, and sweet treats.'
    },
    {
      'name': 'Greenleaf',
      'image': 'assets/flutter_img/res_greenleaf.jpeg',
      'cuisine': 'Healthy & Vegan',
      'location': 'Tilagarh',
      'details': 'Salad bowls, smoothies, and Vegan specials.'
    },
    {
      'name': 'M.M. Bread & Cake',
      'image': 'assets/flutter_img/res_mm_bread_cake.jpeg',
      'cuisine': 'Bakery',
      'location': 'Zindabazar',
      'details': 'Artisanal breads and custom cakes.'
    },
    {
      'name': 'Cha Bazaar',
      'image': 'assets/flutter_img/res_cha_bazaar.jpeg',
      'cuisine': 'Tea & Snacks',
      'location': 'Khan Market',
      'details': 'Traditional Sylheti tea and street Snacks.'
    },
    {
      'name': 'Gobinda Bhog',
      'image': 'assets/flutter_img/res_gobinda_bhog.jpeg',
      'cuisine': 'Vegetarian',
      'location': 'Court Road',
      'details': 'Pure veg restaurant with thali options.'
    },
    {
      'name': 'Sky Lounge',
      'image': 'assets/flutter_img/res_sky_lounge.jpeg',
      'cuisine': 'Pan-Asian',
      'location': 'Hilton Garden Inn',
      'details': 'Rooftop view with sushi and dim sum.'
    },
    {
      'name': 'Spice Villa',
      'image': 'assets/flutter_img/res_spice_villa.jpeg',
      'cuisine': 'Indian & Bangladeshi',
      'location': 'Airport Road',
      'details': 'Spicy curries and biryanis.'
    },
    {
      'name': 'Comfort Restaurant',
      'image': 'assets/flutter_img/res_comfort.jpeg',
      'cuisine': 'International',
      'location': 'Noya Ghat',
      'details': 'Variety of continental dishes and pizzas.'
    },
    {
      'name': 'Panch Vai',
      'image': 'assets/flutter_img/res_panch_vai.jpeg',
      'cuisine': 'Traditional Sylheti',
      'location': 'Zindabazar',
      'details': 'Famous for pitha and local Snacks.'
    },
    {
      'name': 'Panshi',
      'image': 'assets/flutter_img/res_panshi.jpeg',
      'cuisine': 'Mixed Cuisine',
      'location': 'Court Road',
      'details': 'Budget-friendly 99 taka meal combinations.'
    },
    {
      'name': 'Ferdousys',
      'image': 'assets/flutter_img/res_ferdousis.jpeg',
      'cuisine': 'Cafe & Art',
      'location': 'Naiworpul',
      'details': 'Art-themed cafe with coffee and light bites.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 18 Restaurants in Sylhet'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final item = restaurants[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Image.asset(
                item['image']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                item['name']!,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Cuisine: ${item['cuisine']}\n'
                    'Location: ${item['location']}\n'
                    'Details: ${item['details']}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
