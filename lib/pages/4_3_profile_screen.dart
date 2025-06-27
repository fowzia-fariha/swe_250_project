import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_in_flutter/utils/3_custom_colors.dart';
import 'package:food_in_flutter/pages/1_onboarding.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _userRole = 'customer';
  String _photoUrl = 'assets/flutter_img/default_profile.png';
  bool _isLoading = true;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nameController.text = prefs.getString('user_name') ?? 'User Name';
      _userEmail = user?.email ?? 'user@example.com';
      _phoneController.text = prefs.getString('user_phone') ?? '+1 234 567 890';
      _userRole = prefs.getString('user_role') ?? 'customer';
      _photoUrl = prefs.getString('user_photo') ?? 'assets/flutter_img/default_profile.png';
      _isLoading = false;
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_phone', _phoneController.text);
    await prefs.setString('user_role', _userRole);
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveProfileChanges() {
    if (_formKey.currentState!.validate()) {
      _saveUserData();
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_logged_in', false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      // Removed the black app bar completely
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top bar with back button and edit/save buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _toggleEdit,
                  ),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _toggleEdit,
                  ),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveProfileChanges,
                  ),
              ],
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(_photoUrl),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _nameController.text,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _userRole == 'customer' ? 'Customer' : 'Delivery Partner',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal Information
                    const Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      enabled: _isEditing,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) => val!.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email Field (non-editable)
                    TextFormField(
                      controller: TextEditingController(text: _userEmail),
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone Field
                    TextFormField(
                      controller: _phoneController,
                      enabled: _isEditing,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (val) => val!.isEmpty ? 'Phone is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Role Selector (only in edit mode)
                    if (_isEditing) ...[
                      DropdownButtonFormField<String>(
                        value: _userRole,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          prefixIcon: Icon(Icons.work),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'customer', child: Text('Customer')),
                          DropdownMenuItem(value: 'delivery', child: Text('Delivery Partner')),
                        ],
                        onChanged: (value) => setState(() => _userRole = value!),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Logout Button
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _logout,
                        child: const Text('Logout', style: TextStyle(color: Colors.white)),
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
  }
}