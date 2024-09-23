import 'package:business_card_manager/constants/constants.dart';
import 'package:business_card_manager/providers/user.dart';
import 'package:business_card_manager/screens/auth/otp_screen.dart';
import 'package:business_card_manager/screens/home_screen.dart';
import 'package:business_card_manager/screens/onboarding.dart';
import 'package:business_card_manager/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  Gemini.init(apiKey: Constants.GEMINI_API_KEY);
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final AuthService authService = AuthService();
  @override
  void initState() {
    authService.getUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[200],
    ));

    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          textTheme: GoogleFonts.loraTextTheme(),
          scaffoldBackgroundColor: Colors.grey[200],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[200],
          )),
      home: Provider.of<UserProvider>(context).user.token.isEmpty? const OnboardingScreen(): const HomeScreen(),
    );
  }
}
