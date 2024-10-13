import 'dart:async';
import 'dart:convert';
import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/screens/auth/login.dart';
import 'package:business_card_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class VerifyOtp extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  const VerifyOtp(
      {super.key,
      required this.email,
      required this.name,
      required this.password});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  // Store the OTP
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());

  // Timer and countdown variables
  late Timer _timer;
  int _remainingSeconds = 120;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _remainingSeconds = 120; // Reset to 2 minutes
    _canResendOtp = false; // Disable the resend button
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResendOtp = true;
        });
        _timer.cancel();
      }
    });
  }

  Future<void> postData(
      String name, String email, String password, BuildContext context) async {
    final url = Uri.parse('${Constants.uri}/user/signup');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body =
        json.encode({"fullName": name, "email": email, "password": password});

    print('Sending request with body: $body'); // Add this line for debugging

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        showSnackBar(context, 'OTP sent successfully!');
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Exception: $error');
    }
  }

  @override
  void dispose() {
    // Dispose controllers and timer to avoid memory leaks
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  // Function to build each OTP field
  Widget _buildOtpField(int index, BuildContext context) {
    return Container(
      height: 68,
      width: 64,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
        border: Border.all(color: Colors.teal),
      ),
      child: Center(
        child: TextFormField(
          controller: _otpControllers[index],
          onChanged: (value) {
            if (value.length == 1 && index < 3) {
              FocusScope.of(context).nextFocus(); // Move to next field
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus(); // Move to previous field
            }
          },
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
          cursorColor: Colors.teal,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }

  Future<void> checkOTP(BuildContext context, String otp) async {
    final url = Uri.parse('${Constants.uri}/user/verify-otp');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      "fullName": widget.name,
      "email": widget.email,
      "password": widget.password,
      "otp": otp
    });

    // print('Sending request with body: $body'); // Add this line for debugging

    try {
      final response = await http.post(url, headers: headers, body: body);

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        showSnackBar(context, 'Account created successfully, login with the same credentials!');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const Login()), // The new route to push
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else {
        showSnackBar(context, 'Entered OTP was incorrect!');
      }
    } catch (error) {
      print('Exception: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('We sent you a code', style: TextStyle(fontSize: 24)),
              SizedBox(height: screenHeight * 0.05),
              Text('Enter it to verifiy ${widget.email}',
                  style: const TextStyle(fontSize: 18)),
              SizedBox(height: screenHeight * 0.02),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      4, (index) => _buildOtpField(index, context)),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02))),
                  onPressed: () {
                    // Handle OTP submission
                    String otp = _otpControllers
                        .map((controller) => controller.text)
                        .join();
                    checkOTP(context, otp);
                    // Add logic to verify OTP and proceed with registration
                  },
                  child: const Text('Verify OTP'),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Center(
                child: Column(
                  children: [
                    if (_canResendOtp)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.02))),
                        onPressed: _canResendOtp
                            ? () {
                                // Handle Resend OTP logic
                                startTimer(); // Restart the timer
                                postData(widget.name, widget.email,
                                    widget.password, context);
                              }
                            : null, // Disable button if can't resend yet
                        child: const Text('Resend OTP'),
                      ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      _canResendOtp
                          ? 'You can resend the OTP now.'
                          : 'Resend OTP in $_remainingSeconds seconds',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
