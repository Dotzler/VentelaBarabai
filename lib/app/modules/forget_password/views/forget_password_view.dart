import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/app/auth_controller.dart';

class ForgetPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8),
                Text("Malang, Indonesia"),
              ],
            ),
            SizedBox(height: 24),
            Text(
              "Reset Your Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Enter your email to receive a reset link",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            // Email field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            // Send reset link button
            Obx(() {
              return ElevatedButton(
                onPressed: _authController.isLoading.value
                    ? null
                    : () {
                        _authController.sendPasswordResetEmail(
                          _emailController.text.trim(),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3A335),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                ),
                child: _authController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("SEND LINK"),
                          SizedBox(width: 8),
                          Icon(Icons.send),
                        ],
                      ),
              );
            }),
            SizedBox(height: 16),
            // Back to login button
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Back to Login",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
