import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_in_flutter/pages/4_1_category_screen.dart';
import 'package:food_in_flutter/pages/4_2_map_screen.dart';
import 'package:food_in_flutter/pages/4_3_profile_screen.dart';
import 'package:food_in_flutter/pages/4_5_order_screen.dart';
import 'package:food_in_flutter/pages/4_6_cart_screen.dart';

// Add FoodDetailScreen class
class FoodDetailScreen extends StatefulWidget {
  final Map<String, dynamic> foodItem;

  const FoodDetailScreen({Key? key, required this.foodItem}) : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  void _calculateTotal() {
    setState(() {
      _totalPrice = (widget.foodItem['price'] as double) * _quantity;
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _calculateTotal();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _calculateTotal();
      });
    }
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.foodItem['item']} added to cart'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _placeOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Order Confirmed')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 20),
                Text(
                  'Your order for ${widget.foodItem['item']} has been placed!',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total: ৳${_totalPrice.toStringAsFixed(2)}',
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
      appBar: AppBar(
        title: Text(widget.foodItem['item']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              widget.foodItem['image'],
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.foodItem['item'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.foodItem['restaurant'],
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.foodItem['description'],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '৳${widget.foodItem['price'].toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, color: Colors.green),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Quantity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _decrementQuantity,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _incrementQuantity,
                      ),
                      const Spacer(),
                      Text(
                        'Total: ৳${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _addToCart,
                          child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _placeOrder,
                          child: const Text('Place Order', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodHomeScreen extends StatefulWidget {
  const FoodHomeScreen({Key? key}) : super(key: key);
  @override
  _FoodHomeScreenState createState() => _FoodHomeScreenState();
}

class _FoodHomeScreenState extends State<FoodHomeScreen> {
  final List<String> _categories = [
    'All','Fast Food','Healthy','Vegan','Desserts','Drinks','Snacks','Breakfast'
  ];
  int _selectedCategoryIndex = 0;
  final List<Map<String,String>> _recommendations = [
    {'name':'Pizza','image':'assets/flutter_img/pizza.jpeg'},
    {'name':'Burger','image':'assets/flutter_img/burger.jpeg'},
    {'name':'Chicken Fry','image':'assets/flutter_img/chicken_fry.jpeg'},
    {'name':'Cake','image':'assets/flutter_img/cake.jpeg'},
    {'name':'Sushi','image':'assets/flutter_img/sushi.jpeg'},
  ];

  // Updated deals with price and description
  final List<Map<String, dynamic>> _deals = [
    {
      'item':'Burger',
      'restaurant':'The Westin–Pavilion',
      'image':'assets/flutter_img/deal1.jpeg',
      'price': 450.00,
      'description': 'Juicy beef patty with fresh vegetables and special sauce. Served with crispy fries.'
    },
    {
      'item':'Taco',
      'restaurant':'Café 33',
      'image':'assets/flutter_img/deal2.jpeg',
      'price': 320.00,
      'description': 'Crispy corn tortillas filled with seasoned ground beef, lettuce, cheese, and salsa.'
    },
    {
      'item':'Pizza',
      'restaurant':'Sky Lounge',
      'image':'assets/flutter_img/deal3.jpeg',
      'price': 650.00,
      'description': '12-inch hand-tossed pizza with mozzarella cheese, pepperoni, and fresh basil.'
    },
    {
      'item':'Fried Rice',
      'restaurant':'Izumi',
      'image':'assets/flutter_img/deal4.jpeg',
      'price': 380.00,
      'description': 'Traditional Japanese fried rice with vegetables, egg, and your choice of protein.'
    },
    {
      'item':'Platter',
      'restaurant':'Fazlani Gourmet',
      'image':'assets/flutter_img/deal5.jpeg',
      'price': 850.00,
      'description': 'Mixed platter featuring grilled chicken, lamb kebabs, and falafel with hummus.'
    },
    {
      'item':'Burrito',
      'restaurant':'Radisson Blu',
      'image':'assets/flutter_img/deal6.jpeg',
      'price': 350.00,
      'description': 'Large flour tortilla stuffed with rice, beans, cheese, and your choice of filling.'
    },
    {
      'item':'Matar Paneer',
      'restaurant':'Le Méridien',
      'image':'assets/flutter_img/deal7.jpeg',
      'price': 420.00,
      'description': 'Traditional Indian curry with soft paneer cheese and green peas in a rich tomato sauce.'
    },
    {
      'item':'Naan Kabab',
      'restaurant':'Our Place',
      'image':'assets/flutter_img/deal8.jpeg',
      'price': 480.00,
      'description': 'Tender grilled kababs served with freshly baked naan bread and mint chutney.'
    },
    {
      'item':'Tandoori Chicken',
      'restaurant':'Pan Pacific Sonargaon',
      'image':'assets/flutter_img/deal9.jpeg',
      'price': 550.00,
      'description': 'Chicken marinated in yogurt and spices, cooked in a traditional tandoor oven.'
    },
    {
      'item':'Sushi',
      'restaurant':'Grand Sultan Tea Resort',
      'image':'assets/flutter_img/deal10.jpeg',
      'price': 720.00,
      'description': 'Assorted sushi platter with fresh salmon, tuna, and California rolls.'
    },
  ];

  late final ScrollController _recController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
    _recController = ScrollController();
    _autoScrollTimer = Timer.periodic(const Duration(seconds:2),(_){
      if(_recController.hasClients){
        final max = _recController.position.maxScrollExtent;
        final current = _recController.offset;
        double next = current + 150;
        if(next > max) next = 0;
        _recController.animateTo(next,
            duration: const Duration(milliseconds:300), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose(){
    _autoScrollTimer?.cancel();
    _recController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    const bgColor = Color(0xFFFFE0B2);
    const selectionColor = Color(0xFFFFAB91);
    return Scaffold(
      body: Container(
        color: bgColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white, elevation:0, pinned:true,
              title: Container(
                height:44, decoration: BoxDecoration(color:Colors.white, borderRadius: BorderRadius.circular(24)),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search meals, restaurants...',
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              actions: const [
                IconButton(icon: Icon(Icons.favorite_border), onPressed:null),
                IconButton(icon: Icon(Icons.notifications_none), onPressed:null),
              ],
            ),
            SliverPersistentHeader(
                pinned:true,
                delegate: _HeaderDelegate(
                  minHeight:60, maxHeight:60,
                  child: Container(
                    color: bgColor,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal:12, vertical:8),
                        itemCount: _categories.length,
                        itemBuilder: (ctx,i){
                          final selected = i == _selectedCategoryIndex;
                          return GestureDetector(
                            onTap: (){
                              setState(()=>_selectedCategoryIndex = i);
                              if(_categories[i] != 'All'){
                                Navigator.push(context, MaterialPageRoute(builder:(_)=>CategoryScreen(category:_categories[i])));
                              }
                            },
                            child: Container(
                              margin:const EdgeInsets.only(right:10), padding:const EdgeInsets.symmetric(horizontal:14, vertical:8),
                              decoration: BoxDecoration(color: selected? selectionColor: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                              child: Text(_categories[i], style: TextStyle(fontSize:14, color: selected? Colors.white: Colors.black87)),
                            ),
                          );
                        }
                    ),
                  ),
                )
            ),
            SliverToBoxAdapter(
                child: Container(
                    color:bgColor, padding: const EdgeInsets.only(bottom:8),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Padding(padding: EdgeInsets.fromLTRB(12,12,12,4), child: Text('Recommended for You', style: TextStyle(fontSize:18,fontWeight:FontWeight.bold))),
                      SizedBox(
                          height:160,
                          child: ListView.builder(
                              controller: _recController, scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:12),
                              itemCount: _recommendations.length * 100,
                              itemBuilder: (ctx, idx){
                                final item = _recommendations[idx % _recommendations.length];
                                return GestureDetector(
                                  onTap: (){
                                    String target;
                                    switch(item['name']){
                                      case 'Pizza':
                                      case 'Burger':
                                      case 'Chicken Fry': target='Fast Food'; break;
                                      case 'Cake': target='Desserts'; break;
                                      case 'Sushi': target='Healthy'; break;
                                      default: return;
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder:(_)=>CategoryScreen(category:target)));
                                  },
                                  child: Container(
                                    width:150, margin:const EdgeInsets.only(right:8),
                                    decoration:BoxDecoration(borderRadius:BorderRadius.circular(12), image:DecorationImage(image:AssetImage(item['image']!), fit:BoxFit.cover)),
                                    alignment:Alignment.bottomCenter,
                                    child: Container(
                                      width:double.infinity, decoration: const BoxDecoration(color:Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
                                      padding: const EdgeInsets.symmetric(vertical:6),
                                      child: Text(item['name']!, textAlign: TextAlign.center, style: const TextStyle(color:Colors.white, fontSize:14, fontWeight:FontWeight.bold)),
                                    ),
                                  ),
                                );
                              }
                          )
                      )
                    ])
                )
            ),
            SliverPersistentHeader(
                pinned:true,
                delegate:_HeaderDelegate(minHeight:56, maxHeight:56, child:Container(color:bgColor,padding: const EdgeInsets.all(12), alignment: Alignment.centerLeft, child: const Text("Today's Best Deal", style: TextStyle(fontSize:18,fontWeight:FontWeight.bold))))
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((ctx,i){
                  final deal=_deals[i];
                  return GestureDetector(
                    // MODIFIED: Navigate to FoodDetailScreen
                    onTap:() => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailScreen(foodItem: deal),
                      ),
                    ),
                    child:Container(
                        height:120, margin:const EdgeInsets.fromLTRB(12,0,12,12),
                        decoration:BoxDecoration(borderRadius:BorderRadius.circular(12), image:DecorationImage(image:AssetImage(deal['image']), fit:BoxFit.cover)),
                        child:Container(
                            decoration:BoxDecoration(borderRadius:BorderRadius.circular(12), gradient: const LinearGradient(begin:Alignment.bottomCenter, end:Alignment.topCenter, colors:[Colors.black54,Colors.transparent])), padding: const EdgeInsets.all(8), alignment: Alignment.bottomLeft,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                              Text(deal['item'], style: const TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold)),
                              Text(deal['restaurant'], style: const TextStyle(color:Colors.white70,fontSize:14)),
                              Text('৳${deal['price'].toStringAsFixed(2)}', style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
                            ])
                        )
                    ),
                  );
                }, childCount:_deals.length)
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFE0B2),
        selectedItemColor: const Color(0xFFFFAB91),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MapScreen()));
            Future.delayed(Duration.zero, () => setState(() => _currentIndex = 0));
          }
          else if (index == 2) { // Orders tab
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
            Future.delayed(Duration.zero, () => setState(() => _currentIndex = 0));
          }
          else if (index == 3) { // Cart tab
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            Future.delayed(Duration.zero, () => setState(() => _currentIndex = 0));
          }else if (index == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            Future.delayed(Duration.zero, () => setState(() => _currentIndex = 0));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate{
  final Widget child; final double minHeight; final double maxHeight;
  _HeaderDelegate({required this.child, required this.minHeight, required this.maxHeight});
  @override double get minExtent=>minHeight; @override double get maxExtent=>maxHeight;
  @override Widget build(BuildContext c,double s,bool o)=>Material(elevation:o?4:0, child:child);
  @override bool shouldRebuild(covariant _HeaderDelegate old)=>true;
}