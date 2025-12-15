import 'package:flutter/material.dart';
import 'package:cuidadex_frontend/pages/login_page.dart';


class SplashCuidadex extends StatefulWidget {
  const SplashCuidadex({super.key});

  @override
  State<SplashCuidadex> createState() => _SplashCuidadexState();
}

class _SplashCuidadexState extends State<SplashCuidadex> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0ECF4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 260,
              child: Image.asset(
                'assets/images/cuidadex_logo.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "CUIDADEX",
              style: TextStyle(
                fontSize: 32,
                color: Color(0xFF6C41B5),
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Para quem você ama, o melhor cuidado.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6C41B5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
