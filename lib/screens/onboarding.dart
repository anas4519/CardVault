import 'package:business_card_manager/screens/auth/create_account_screen.dart';
import 'package:business_card_manager/screens/auth/login.dart';
import 'package:business_card_manager/screens/privacy_policy.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.15,
              ),
              const Text(
                'All your business cards',
                style: TextStyle(
                    // color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              const Text(
                'Together in one place!',
                style: TextStyle(
                    // color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Center(
                child: Column(
                  children: [
                    Transform.rotate(
                      angle: 90 * 3.1415927 / 180, // Rotate 90 degrees
                      child: Image.asset('assets/mo-removebg-preview.png'),
                    ),
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.07,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> CreateAccountScreen()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth*0.04),
                          ),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.07,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const Login()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth*0.04),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Row(
                      children: [
                        SizedBox(width: screenWidth*0.05,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const PrivacyPolicy()));
                            },
                            child: const Text(
                                'By signing up, you agree to our Terms, Privacy Policy and Cookie use.', style: TextStyle(color: Colors.teal, fontSize: 12),),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
