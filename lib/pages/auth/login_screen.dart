import 'package:flutter/material.dart';
import '../home_pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png', // Pastikan file ini tersedia
          height: 40,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/login.png',
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'Login dengan akunmu sekarang',
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 35),
            const TextField(
              decoration: InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.account_circle_outlined),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_clock_outlined),
              ),
            ),
            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF68A77C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
