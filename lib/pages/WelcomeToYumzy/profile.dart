import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this dependency in pubspec.yaml
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image; // Stores selected image
  final picker = ImagePicker(); // Image picker instance

  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _emailController = TextEditingController(text: "johndoe@email.com");
  final TextEditingController _phoneController = TextEditingController(text: "+1234567890");

  bool isEditing = false; // Tracks editing state

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            GestureDetector(
              onTap: _pickImage, // Allows user to change profile image
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : AssetImage("images/default_user.png") as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Icons.camera_alt, size: 18, color: Colors.orange),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Editable Fields
            buildTextField("Full Name", _nameController, isEditing),
            buildTextField("Email", _emailController, isEditing),
            buildTextField("Mobile Number", _phoneController, isEditing),

            SizedBox(height: 20),

            // Edit / Save Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = !isEditing; // Toggle edit mode
                });
                if (!isEditing) {
                  // Save logic (if needed)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Profile Updated Successfully")),
                  );
                }
              },
              child: Text(isEditing ? "Save" : "Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to create text fields
  Widget buildTextField(String label, TextEditingController controller, bool isEditable) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        enabled: isEditable, // Editable when in edit mode
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}

class ImageSource {
  static var gallery;
}

class ImagePicker {
  pickImage({required source}) {}
}
