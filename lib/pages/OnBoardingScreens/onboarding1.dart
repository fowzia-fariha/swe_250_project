import 'package:flutter/material.dart';
import 'onboarding2.dart';

class onboarding1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              "images/on5.jpg",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Text(
                  "Savor the Flavor, Love Every Bite",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Choose from a wide variety of delicious dishes.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => onboarding2()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                "images/right_arrow.png",
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
