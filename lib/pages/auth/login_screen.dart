import 'package:flutter/material.dart';
import '../home_pages.dart';
import '../../services/login_service.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
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

            // Username
            TextField(
              controller: _usernameCtrl,
              decoration:  InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.account_circle_outlined),
              ),
            ),
            const SizedBox(height: 15),

            // Password
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration:  InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_clock_outlined),
              ),
            ),
            const SizedBox(height: 45),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF68A77C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Login'),
                onPressed: () async {
                  String username = _usernameCtrl.text;
                  String password = _passwordCtrl.text;

                  bool result =
                      await LoginService().login(username, password);

                  if (result == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  } else {
                    AlertDialog alertDialog = AlertDialog(
                      content: const Text("Username atau Password Tidak Valid"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                    showDialog(context: context, builder: (context) => alertDialog);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
