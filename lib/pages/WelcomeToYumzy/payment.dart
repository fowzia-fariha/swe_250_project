import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = "bKash"; // Default selected payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Payment Method"), backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose your preferred payment method:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Payment Options
            buildPaymentOption("bKash", "images/bkash.png"),
            buildPaymentOption("Nagad", "images/nagad.png"),
            buildPaymentOption("Rocket", "images/rocket.png"),

            SizedBox(height: 30),

            // Proceed Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment processing here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Proceeding with $_selectedPayment")),
                  );
                },
                child: Text("Proceed to Pay"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to create a payment option
  Widget buildPaymentOption(String paymentName, String imagePath) {
    return ListTile(
      leading: Image.asset(imagePath, height: 40), // Payment Icon
      title: Text(paymentName, style: TextStyle(fontSize: 18)),
      trailing: Radio<String>(
        value: paymentName,
        groupValue: _selectedPayment,
        onChanged: (String? value) {
          setState(() {
            _selectedPayment = value!;
          });
        },
      ),
    );
  }
}
