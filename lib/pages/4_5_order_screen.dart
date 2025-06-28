// lib/screens/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:food_in_flutter/utils/3_custom_colors.dart'; // Import AppColors

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> _pendingOrders = [];
  List<Map<String, dynamic>> _previousOrders = [];
  List<Map<String, dynamic>> _deliveryBoys = [];
  String _selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _pendingOrders = [
      {
        'id': 'ORD001',
        'items': ['Burger', 'Fries'],
        'restaurant': 'Burger King',
        'total': 850.00,
        'date': '2023-06-15',
        'status': 'Preparing'
      },
      {
        'id': 'ORD002',
        'items': ['Pizza', 'Coke'],
        'restaurant': 'Pizza Hut',
        'total': 1200.00,
        'date': '2023-06-16',
        'status': 'On the way'
      }
    ];

    _previousOrders = [
      {
        'id': 'ORD003',
        'items': ['Sushi Platter'],
        'restaurant': 'Sushi House',
        'total': 1500.00,
        'date': '2023-06-10',
        'status': 'Delivered'
      },
      {
        'id': 'ORD004',
        'items': ['Fried Rice', 'Spring Rolls'],
        'restaurant': 'Chinese Corner',
        'total': 750.00,
        'date': '2023-06-05',
        'status': 'Delivered'
      }
    ];

    _deliveryBoys = [
      {'name': 'Bob', 'rating': 4.7, 'status': 'Available'},
      {'name': 'Alice', 'rating': 4.9, 'status': 'Available'},
      {'name': 'Charlie', 'rating': 4.5, 'status': 'On delivery'},
    ];
  }

  void _updateOrderStatus(String orderId, String newStatus) {
    setState(() {
      final order = _pendingOrders.firstWhere((order) => order['id'] == orderId);
      order['status'] = newStatus;

      if (newStatus == 'Delivered') {
        _pendingOrders.remove(order);
        _previousOrders.insert(0, order);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontSize: 16)), // Reduced to 16
        backgroundColor: AppColors.selectionColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Status selection buttons
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01,
              horizontal: screenWidth * 0.05,
            ),
            child: Row(
              children: [
                _buildStatusButton('Pending', Icons.access_time),
                SizedBox(width: screenWidth * 0.03),
                _buildStatusButton('Delivered', Icons.check_circle),
              ],
            ),
          ),

          // Content based on selected status
          if (_selectedStatus == 'Pending') ...[
            // Pending orders header
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.06,
                screenHeight * 0.008,
                screenWidth * 0.06,
                screenHeight * 0.01,
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pending Orders',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Reduced to 14
                ),
              ),
            ),

            // Pending orders list
            Expanded(
              child: ListView.builder(
                itemCount: _pendingOrders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(
                    _pendingOrders[index],
                    true,
                    screenWidth,
                    screenHeight,
                  );
                },
              ),
            ),

            // Delivery boys header
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.06,
                screenHeight * 0.015,
                screenWidth * 0.06,
                screenHeight * 0.008,
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Available Delivery Boys',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Reduced to 14
                ),
              ),
            ),

            // Delivery boys horizontal list
            SizedBox(
              height: screenHeight * 0.14,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _deliveryBoys.length,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                itemBuilder: (context, index) {
                  final boy = _deliveryBoys[index];
                  if (boy['status'] == 'Available') {
                    return _buildDeliveryBoyCard(boy, screenWidth);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Bottom spacing
            SizedBox(height: screenHeight * 0.015),
          ] else ...[
            // Previous orders header
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.06,
                screenHeight * 0.008,
                screenWidth * 0.06,
                screenHeight * 0.01,
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Previous Orders',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Reduced to 14
                ),
              ),
            ),

            // Previous orders list
            Expanded(
              child: ListView.builder(
                itemCount: _previousOrders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(
                    _previousOrders[index],
                    false,
                    screenWidth,
                    screenHeight,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status, IconData icon) {
    return Expanded(
      child: Container(
        height: 36, // Reduced to 36
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedStatus == status
                ? AppColors.selectionColor
                : Colors.grey[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Reduced to 8
            ),
          ),
          onPressed: () => setState(() => _selectedStatus = status),
          icon: Icon(icon, size: 18, color: Colors.white), // Reduced to 18
          label: Text(
            status,
            style: const TextStyle(
              fontSize: 12, // Reduced to 12
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(
      Map<String, dynamic> order,
      bool isPending,
      double screenWidth,
      double screenHeight,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 5, // Reduced to 5
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10), // Reduced to 10
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3, // Reduced to 3
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Reduced to 10
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order['id']}',
                  style: const TextStyle(
                      fontSize: 13, // Reduced to 13
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                    order['date'],
                    style: const TextStyle(fontSize: 11) // Reduced to 11
                ),
              ],
            ),

            const SizedBox(height: 4), // Reduced to 4

            // Restaurant name
            Text(
              order['restaurant'],
              style: TextStyle(
                  fontSize: 12, // Reduced to 12
                  color: Colors.grey[600]
              ),
            ),

            const SizedBox(height: 8), // Reduced to 8

            // Order items
            Column(
              children: [
                for (var item in order['items'])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3), // Reduced to 3
                    child: Row(
                      children: [
                        const Icon(Icons.fastfood, size: 14, color: Colors.orange), // Reduced to 14
                        const SizedBox(width: 6), // Reduced to 6
                        Text(item, style: const TextStyle(fontSize: 11)), // Reduced to 11
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10), // Reduced to 10
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 8), // Reduced to 8

            // Order footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total amount
                Text(
                  '৳${order['total']}',
                  style: const TextStyle(
                      fontSize: 13, // Reduced to 13
                      fontWeight: FontWeight.bold
                  ),
                ),

                // Status and action button (only for pending orders)
                if (isPending) ...[
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, // Reduced to 6
                              vertical: 3  // Reduced to 3
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(14), // Reduced to 14
                          ),
                          child: Text(
                            order['status'],
                            style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 10 // Reduced to 10
                            ),
                          ),
                        ),

                        const SizedBox(width: 6), // Reduced to 6

                        // Deliver button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, // Reduced to 10
                                vertical: 6   // Reduced to 6
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Reduced to 8
                            ),
                          ),
                          onPressed: () => _updateOrderStatus(
                              order['id'], 'Delivered'),
                          child: const Text(
                              'Delivered',
                              style: TextStyle(fontSize: 10) // Reduced to 10
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryBoyCard(
      Map<String, dynamic> boy,
      double screenWidth
      ) {
    return Container(
      width: screenWidth * 0.19, // Reduced to 0.19 (2/3 of 0.28)
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.015), // Reduced spacing
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10), // Reduced to 10
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2, // Reduced to 2
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced to 8
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 16, // Reduced to 16
              backgroundColor: AppColors.selectionColor,
              child: const Icon(Icons.person, size: 18, color: Colors.white), // Reduced to 18
            ),

            const SizedBox(height: 6), // Reduced to 6

            // Name
            Text(
              boy['name'],
              style: const TextStyle(
                  fontSize: 10, // Reduced to 10
                  fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),

            const SizedBox(height: 3), // Reduced to 3

            // Rating - kept visible on the card
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 12), // Reduced to 12
                const SizedBox(width: 2),
                Text(
                    '${boy['rating']}',
                    style: const TextStyle(fontSize: 10) // Reduced to 10
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}