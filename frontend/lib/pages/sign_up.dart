import 'package:flutter/material.dart';
import 'package:drop_app/pages/category_selection_page.dart'; // Import the Category Selection page
import 'package:drop_app/pages/log_in.dart';
import 'package:drop_app/api/api_service.dart';
import 'package:drop_app/models/user_model.dart';
import 'package:drop_app/global.dart' as globals;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      
      // Call the insertUser function
      final user = await ApiService.insertUser(
        userName: nameController.text.trim(),
        userSurname: surnameController.text.trim(),
        userCardnum: studentIdController.text.trim(),
        userLocation: locationController.text.trim(),
        hash: passwordController.text.trim(),
      );

      // Store the returned userID in global userData
      globals.userData = user;    //MUST UNCOMMENT

      // Navigate to the next page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategorySelectionPage()),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up failed: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30),
                // Name input
                _buildTextField(nameController, 'Name', Icons.person),
                SizedBox(height: 15),
                // Surname input
                _buildTextField(surnameController, 'Surname', Icons.person_outline),
                SizedBox(height: 15),
                // Student ID input
                _buildTextField(studentIdController, 'Student ID', Icons.school, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student ID';
                  }
                  if (!RegExp(r'^2\d{7}$').hasMatch(value)) {
                    return 'Invalid Student ID';
                  }
                  return null;
                }),
                SizedBox(height: 15),
                // Location input
                _buildTextField(locationController, 'Location', Icons.location_on),
                SizedBox(height: 5), // Add a small gap between the field and the description
                Text(
                  "Example: W8, N1, N19...", 
                  style: TextStyle(
                    color: Colors.grey, // Use gray for the description text
                    fontSize: 14,        // Adjust the font size if needed
                    fontStyle: FontStyle.italic, // Optional: make it italic for distinction
                  ),
                ),
                SizedBox(height: 15),
                // Password input
                _buildTextField(passwordController, 'Password', Icons.lock, obscureText: true),
                SizedBox(height: 15),
                // Confirm Password input
                _buildTextField(confirmPasswordController, 'Confirm Password', Icons.lock_outline, obscureText: true, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                }),
                SizedBox(height: 20),
                // Sign-up button
                ElevatedButton(
                  onPressed: isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 106, 157),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                SizedBox(height: 20),
                // Log in redirection
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
                      child: Text(
                        'Log In',
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
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        filled: true,
        fillColor: const Color.fromARGB(255, 230, 229, 246),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator ?? (value) => value == null || value.isEmpty ? 'Please enter your $hintText' : null,
    );
  }
}