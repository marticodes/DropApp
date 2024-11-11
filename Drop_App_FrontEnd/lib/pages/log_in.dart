import 'package:flutter/material.dart';
import 'package:drop_app/homepage.dart'; // Import the HomePage file
import 'package:drop_app/pages/sign_up.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                'Enter your credential to login',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              // Username field
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Username',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 229, 246),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Password field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Password',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 229, 246),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Login button
              ElevatedButton(
                onPressed: () {
                  // Navigate to HomePage when login is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 108, 106, 157),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
              SizedBox(height: 20),
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 108, 106, 157),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
