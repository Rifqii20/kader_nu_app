import 'package:flutter/material.dart';
import 'package:kader_nu/providers/aset_provider.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:kader_nu/providers/jamaah_provider.dart';
import 'package:kader_nu/providers/kegiatan_provider.dart';
import 'package:kader_nu/splash_screen.dart';
import 'package:provider/provider.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AsetProvider()),
        ChangeNotifierProvider(create: (context) => JamaahProvider()),
        ChangeNotifierProvider(create: (context) => KegiatanProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}