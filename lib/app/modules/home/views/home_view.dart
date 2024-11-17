// lib/features/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:SneakerSpace/app/modules/login_page/views/login_view.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Image
              Container(
                width: 275,
                height: 275,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/SneakerSpace.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Welcome Text
              Text(
                "Welcome to Sneaker Space!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                "Explore the Sneaker Space, Discover Your Dream Shoes!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 32),
              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to login page
                  Get.to(LoginPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3A335), // Gold Color
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Text(
                  "GET STARTED",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}