import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) {
        return;
      }
      if (AuthService.instance.isSignedIn) {
        goToMain(context);
      } else {
        goToLogin(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 42,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'SMARTCART',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Shop smarter. Choose better.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 26),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
