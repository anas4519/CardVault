import 'dart:convert';
import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/providers/user.dart';
import 'package:business_card_manager/screens/onboarding.dart';
import 'package:business_card_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> getUserData(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/user/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/user/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const OnboardingScreen()),
        (route) => false);
  }
}
// appBar: AppBar(
      //   title: Text(
      //     widget.companyName,
      //     style: const TextStyle(fontSize: 16),
      //   ),
      //   centerTitle: true,
      // ),