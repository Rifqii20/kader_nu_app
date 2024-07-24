// lib/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/pages/home_page.dart';
import 'package:kader_nu/pages/login_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Provider.of<AuthProvider>(context, listen: false).token == null
            ? LoginPage()
            : HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/splash.png', width: 200, height: 200),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
