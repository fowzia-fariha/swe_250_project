import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Restaurant {
  final String name;
  final String image;
  final String cuisine;
  final String location;
  final String details;
  final LatLng position;

  Restaurant({
    required this.name,
    required this.image,
    required this.cuisine,
    required this.location,
    required this.details,
    required this.position,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};
  LatLng? _currentPosition;
  bool _isLoading = true;

  // Sylhet bounding box coordinates (approximate)
  static const double minLat = 24.70;
  static const double maxLat = 25.00;
  static const double minLng = 91.60;
  static const double maxLng = 92.00;
  static const LatLng sylhetCenter = LatLng(24.8949, 91.8687);

  // Fixed positions for specific landmarks
  static const LatLng iictSustPosition = LatLng(24.9145, 91.9211);
  static const LatLng zindabazarPosition = LatLng(24.8950, 91.8680);
  static const LatLng airportRoadPosition = LatLng(24.9586, 91.8678);
  static const LatLng courtRoadPosition = LatLng(24.8964, 91.8703);

  // List of Sylhet restaurants with realistic positions
  final List<Restaurant> _sylhetRestaurants = [
    Restaurant(
      name: 'The Glasshouse',
      image: 'assets/flutter_img/res_the_glasshouse.jpeg',
      cuisine: 'Local & Continental',
      location: 'Grand Sultan Tea Resort & Golf',
      details: 'Scenic riverside dining with diverse menu.',
      position: const LatLng(24.9789, 91.8736),
    ),
    Restaurant(
      name: 'Cafe Dreamland',
      image: 'assets/flutter_img/res_cafe_dreamland.jpeg',
      cuisine: 'Cafe & Snacks',
      location: 'Nilkuthi, Sylhet',
      details: 'Cozy coffee spot popular among youngsters.',
      position: const LatLng(24.9082, 91.8421),
    ),
    Restaurant(
      name: 'Mezbaan',
      image: 'assets/flutter_img/res_mezbaan.jpeg',
      cuisine: 'Bangladeshi',
      location: 'Mezanine City Center',
      details: 'Authentic Sylheti dishes in a casual setting.',
      position: const LatLng(24.8958, 91.8724),
    ),
    Restaurant(
      name: 'Royal Dine',
      image: 'assets/flutter_img/res_royal_dine.jpeg',
      cuisine: 'Asian & BBQ',
      location: 'Zindabazar',
      details: 'BBQ buffet and family-friendly atmosphere.',
      position: zindabazarPosition,
    ),
    Restaurant(
      name: 'Acropolis',
      image: 'assets/flutter_img/res_acropolis.jpeg',
      cuisine: 'Mediterranean',
      location: 'Khanpur',
      details: 'Greek-inspired menu with vegetarian options.',
      position: const LatLng(24.8823, 91.8837),
    ),
    Restaurant(
      name: 'Fatima\'s Steakhouse',
      image: 'assets/flutter_img/res_fatimas_steakhouse.jpeg',
      cuisine: 'Steak & Grill',
      location: 'Court Road',
      details: 'Premium steaks and grilled specialties.',
      position: courtRoadPosition,
    ),
    Restaurant(
      name: 'Tea Hut',
      image: 'assets/flutter_img/res_tea_hut.jpeg',
      cuisine: 'Beverages & Light Bites',
      location: 'Sylhet City Center',
      details: 'Wide variety of teas and light Snacks-items.',
      position: const LatLng(24.9015, 91.8612),
    ),
    Restaurant(
      name: 'Salvia\'s Kitchen',
      image: 'assets/flutter_img/res_salvias_kitchen.jpeg',
      cuisine: 'Desserts & Bakery',
      location: 'Guwahati Point',
      details: 'Fresh pastries, cakes, and sweet treats.',
      position: const LatLng(24.9218, 91.8496),
    ),
    Restaurant(
      name: 'Greenleaf',
      image: 'assets/flutter_img/res_greenleaf.jpeg',
      cuisine: 'Healthy & Vegan',
      location: 'Tilagarh',
      details: 'Salad bowls, smoothies, and Vegan specials.',
      position: const LatLng(24.9367, 91.8914),
    ),
    Restaurant(
      name: 'M.M. Bread & Cake',
      image: 'assets/flutter_img/res_mm_bread_cake.jpeg',
      cuisine: 'Bakery',
      location: 'Zindabazar',
      details: 'Artisanal breads and custom cakes.',
      position: zindabazarPosition,
    ),
    Restaurant(
      name: 'Cha Bazaar',
      image: 'assets/flutter_img/res_cha_bazaar.jpeg',
      cuisine: 'Tea & Snacks',
      location: 'Khan Market',
      details: 'Traditional Sylheti tea and street Snacks.',
      position: const LatLng(24.8901, 91.8527),
    ),
    Restaurant(
      name: 'Gobinda Bhog',
      image: 'assets/flutter_img/res_gobinda_bhog.jpeg',
      cuisine: 'Vegetarian',
      location: 'Court Road',
      details: 'Pure veg restaurant with thali options.',
      position: courtRoadPosition,
    ),
    Restaurant(
      name: 'Sky Lounge',
      image: 'assets/flutter_img/res_sky_lounge.jpeg',
      cuisine: 'Pan-Asian',
      location: 'Hilton Garden Inn',
      details: 'Rooftop view with sushi and dim sum.',
      position: const LatLng(24.9324, 91.8745),
    ),
    Restaurant(
      name: 'Spice Villa',
      image: 'assets/flutter_img/res_spice_villa.jpeg',
      cuisine: 'Indian & Bangladeshi',
      location: 'Airport Road',
      details: 'Spicy curries and biryanis.',
      position: airportRoadPosition,
    ),
    Restaurant(
      name: 'Comfort Restaurant',
      image: 'assets/flutter_img/res_comfort.jpeg',
      cuisine: 'International',
      location: 'Noya Ghat',
      details: 'Variety of continental dishes and pizzas.',
      position: const LatLng(24.8765, 91.8921),
    ),
    Restaurant(
      name: 'Panch Vai',
      image: 'assets/flutter_img/res_panch_vai.jpeg',
      cuisine: 'Traditional Sylheti',
      location: 'Zindabazar',
      details: 'Famous for pitha and local Snacks.',
      position: zindabazarPosition,
    ),
    Restaurant(
      name: 'Panshi',
      image: 'assets/flutter_img/res_panshi.jpeg',
      cuisine: 'Mixed Cuisine',
      location: 'Court Road',
      details: 'Budget-friendly 99 taka meal combinations.',
      position: courtRoadPosition,
    ),
    Restaurant(
      name: 'Ferdousys',
      image: 'assets/flutter_img/res_ferdousis.jpeg',
      cuisine: 'Cafe & Art',
      location: 'Naiworpul',
      details: 'Art-themed cafe with coffee and light bites.',
      position: const LatLng(24.9123, 91.9087),
    ),
  ];

  // Generate random positions within Sylhet boundaries
  static LatLng generatePosition() {
    final random = Random();
    final lat = minLat + random.nextDouble() * (maxLat - minLat);
    final lng = minLng + random.nextDouble() * (maxLng - minLng);
    return LatLng(lat, lng);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addRestaurantMarkers();
    _addSpecialMarkers();
  }

  void _addSpecialMarkers() {
    // Add IICT SUST marker
    _markers.add(
      Marker(
        markerId: const MarkerId('iict_sust'),
        position: iictSustPosition,
        infoWindow: const InfoWindow(
          title: 'IICT, SUST',
          snippet: 'Shahjalal University of Science and Technology',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  void _addRestaurantMarkers() {
    for (final restaurant in _sylhetRestaurants) {
      _markers.add(
        Marker(
          markerId: MarkerId(restaurant.name),
          position: restaurant.position,
          infoWindow: InfoWindow(
            title: restaurant.name,
            snippet: restaurant.cuisine,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () => _showRestaurantDetails(context, restaurant),
        ),
      );
    }
  }

  void _showRestaurantDetails(BuildContext context, Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  restaurant.image,
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                restaurant.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                restaurant.cuisine,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_pin, size: 20, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      restaurant.location,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                restaurant.details,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Close', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services disabled. Please enable.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions denied')),
        );
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions permanently denied. Enable in settings.'),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentPosition!,
            infoWindow: const InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );

        // Zoom to show both Sylhet center and current location
        _zoomToFit();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location error: ${e.toString()}')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _zoomToFit() async {
    if (_currentPosition == null) return;

    final controller = await _mapController.future;
    final bounds = LatLngBounds(
      southwest: const LatLng(minLat, minLng),
      northeast: const LatLng(maxLat, maxLng),
    );

    final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
    controller.animateCamera(cameraUpdate);
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.isEmpty) return;

    try {
      final locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('search_${_searchController.text}'),
              position: latLng,
              infoWindow: InfoWindow(title: _searchController.text),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
        });

        final controller = await _mapController.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: sylhetCenter,
              zoom: 12,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) {
              _mapController.complete(controller);
              // Zoom to fit Sylhet boundaries after map loads
              Future.delayed(const Duration(milliseconds: 500), _zoomToFit);
            },
            compassEnabled: true,
            mapToolbarEnabled: true,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 20,
                    padding: const EdgeInsets.all(8),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Search restaurants...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        isDense: true,
                      ),
                      onSubmitted: (value) => _searchLocation(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    iconSize: 20,
                    padding: const EdgeInsets.all(8),
                    onPressed: _searchLocation,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFFFFAB91),
            onPressed: _getCurrentLocation,
            mini: true,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: const Color(0xFF4CAF50),
            onPressed: _zoomToFit,
            mini: true,
            child: const Icon(Icons.zoom_out_map),
          ),
        ],
      ),
    );
  }
}