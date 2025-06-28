import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_in_flutter/utils/3_custom_colors.dart';
import 'package:food_in_flutter/pages/1_onboarding.dart';

import '2_signin_signup.dart';

class DeliveryProfileScreen extends StatefulWidget {
  const DeliveryProfileScreen({Key? key}) : super(key: key);

  @override
  _DeliveryProfileScreenState createState() => _DeliveryProfileScreenState();
}

class _DeliveryProfileScreenState extends State<DeliveryProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String _status = "Available";
  bool _loading = false;

  // User editable fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  // Orders data (simulated)
  final List<Map<String, dynamic>> _pendingOrders = [
    {'id': '#ORD001', 'customer': 'John Doe', 'address': '123 Main St', 'items': 3, 'amount': 24.99},
    {'id': '#ORD002', 'customer': 'Jane Smith', 'address': '456 Oak Ave', 'items': 5, 'amount': 42.50},
  ];

  final List<Map<String, dynamic>> _completedOrders = [
    {'id': '#ORD003', 'customer': 'Robert Brown', 'address': '789 Pine Rd', 'items': 2, 'amount': 18.75},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    setState(() {
      _user = user;
      _nameController.text = user?.displayName ?? '';
      _phoneController.text = user?.phoneNumber ?? '';
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userType');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
          (route) => false,
    );
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });
    // Update status in database
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _user!.updateDisplayName(_nameController.text);
      // Phone number update requires additional verification
      if (_phoneController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number update requires verification'),
            backgroundColor: Colors.blue,
          ),
        );
      }

      // Reload user data
      await _user!.reload();
      setState(() => _user = _auth.currentUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _updatePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both fields are required'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      // Reauthenticate user
      final credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: _currentPasswordController.text,
      );
      await _user!.reauthenticateWithCredential(credential);

      // Update password
      await _user!.updatePassword(_newPasswordController.text);

      // Clear fields
      _currentPasswordController.clear();
      _newPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated'), backgroundColor: Colors.green),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Profile',
          style: TextStyle(fontSize: 18), // Reduced font size
        ),
        backgroundColor: AppColors.selectionColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // Profile Section - Made more compact
            Padding(
              padding: const EdgeInsets.all(12.0), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40, // Smaller avatar
                    backgroundImage: AssetImage('assets/delivery_avatar.png'),
                  ),
                  const SizedBox(height: 12), // Reduced spacing

                  // Editable Name Field
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(fontSize: 14), // Smaller font
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _updateProfile(),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced spacing

                  // Email (read-only)
                  TextFormField(
                    initialValue: _user!.email,
                    style: const TextStyle(fontSize: 14), // Smaller font
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      enabled: false,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced spacing

                  // Editable Phone Field
                  TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(fontSize: 14), // Smaller font
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: const TextStyle(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _updateProfile(),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced spacing

                  // Status Selector - Made more compact
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: _status,
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      isDense: true, // More compact
                      underline: const SizedBox(),
                      onChanged: (String? newValue) {
                        if (newValue != null) _updateStatus(newValue);
                      },
                      items: ['Available', 'On Delivery', 'Offline']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                              value,
                              style: const TextStyle(fontSize: 14) // Smaller font
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced spacing

                  // Password Update Section
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero, // Remove default padding
                    title: const Text(
                        'Change Password',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold) // Smaller font
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _currentPasswordController,
                              style: const TextStyle(fontSize: 14), // Smaller font
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Current Password',
                                labelStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _newPasswordController,
                              style: const TextStyle(fontSize: 14), // Smaller font
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'New Password',
                                labelStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              ),
                              onPressed: _updatePassword,
                              child: const Text(
                                  'Update Password',
                                  style: TextStyle(fontSize: 14) // Smaller font
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Orders Tabs - Made more compact
            Container(
              height: 40, // Reduced height
              child: TabBar(
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    child: Text(
                        'Pending',
                        style: TextStyle(fontSize: 12) // Smaller font
                    ),
                  ),
                  Tab(
                    child: Text(
                        'Completed',
                        style: TextStyle(fontSize: 12) // Smaller font
                    ),
                  ),
                  Tab(
                    child: Text(
                        'All',
                        style: TextStyle(fontSize: 12) // Smaller font
                    ),
                  ),
                ],
                indicatorColor: AppColors.selectionColor,
                labelColor: Colors.black,
              ),
            ),

            // Order List - Made more compact
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(_pendingOrders),
                  _buildOrderList(_completedOrders),
                  _buildOrderList([..._pendingOrders, ..._completedOrders]),
                ],
              ),
            ),

            // Logout Button - Made more compact
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _logout,
                child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 14) // Smaller font
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
          child: Text(
              'No orders found',
              style: TextStyle(fontSize: 14) // Smaller font
          )
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Tighter margins
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12), // Tighter padding
            title: Text(
              'Order ${order['id']}',
              style: const TextStyle(fontSize: 14), // Smaller font
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${order['customer']}',
                  style: const TextStyle(fontSize: 12), // Smaller font
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${order['address']}',
                  style: const TextStyle(fontSize: 11), // Smaller font
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${order['items']} items',
                  style: const TextStyle(fontSize: 11), // Smaller font
                ),
              ],
            ),
            trailing: Text(
              '\$${order['amount'].toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Smaller font
            ),
            onTap: () {
              // Show order details in a compact dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  title: Text(
                    'Order ${order['id']}',
                    style: const TextStyle(fontSize: 16), // Appropriate size
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer: ${order['customer']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Address: ${order['address']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Items: ${order['items']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Amount: \$${order['amount'].toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (orders == _pendingOrders)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Order ${order['id']} marked as delivered',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Mark as Delivered',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}