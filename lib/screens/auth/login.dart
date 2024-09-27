import 'dart:convert';
import 'package:business_card_manager/providers/user.dart';
import 'package:business_card_manager/screens/home_screen.dart';
import 'package:business_card_manager/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:business_card_manager/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final passwordRegex =
        RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Invalid Password';
    }
    return null;
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      postData(_emailController.text, _passwordController.text, context);
    }
  }

Future<void> postData(String email, String password, BuildContext context) async {
  final url = Uri.parse('${Constants.uri}/user/signin');
  final headers = {
    'Content-Type': 'application/json',
  };
  final body = json.encode({"email": email, "password": password});

  try {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('x-auth-token', jsonDecode(response.body)['token']);
      
      userProvider.setUser(response.body);
      
      await AuthService().getUserData(context);

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        (route) => false
      );
    } else if (response.statusCode == 401) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonDecode(response.body)['error']))
      );
    }
  } catch (error) {
    print('Error: $error');
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: $error'),
    ));
  }
}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter your Credentials',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email Address Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'info@example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    validator: _validateEmail,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Create Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordView,
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Password Requirement Note
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
            SizedBox(height: screenWidth*0.05,),
            SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.075,
              child: TextButton(
                onPressed: _login,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
