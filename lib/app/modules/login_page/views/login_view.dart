import 'package:SneakerSpace/app/auth_controller.dart';
import 'package:SneakerSpace/app/modules/forget_password/views/forget_password_view.dart';
import 'package:SneakerSpace/app/modules/signup_page/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Let's Sign You In",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 32),
                // Email field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                // Password field
                Obx(() {
                  return TextField(
                    controller: _passwordController,
                    obscureText: _authController.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_authController.isPasswordHidden.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: _authController.togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  );
                }),
                SizedBox(height: 24),
                // Sign in button with Firebase authentication
                Obx(() {
                  return ElevatedButton(
                    onPressed: _authController.isLoading.value
                        ? null
                        : () {
                            _authController.loginUser(
                              _emailController.text,
                              _passwordController.text,
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
                              Text("SIGN IN", style: TextStyle(color: Colors.white),),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white,),
                            ],
                          ),
                  );
                }),
                SizedBox(height: 16),
                // Sign up text
                TextButton(
                  onPressed: () {
                    Get.to(SignUpPage());
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => ForgetPasswordPage());
                  },
                  child: Text(
                    "Forgot Password?",
                    style:
                        TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}