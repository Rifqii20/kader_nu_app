// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:kader_nu/pages/aset_page.dart';
import 'package:kader_nu/pages/jamaah_page.dart';
import 'package:kader_nu/pages/kegiatan_page.dart';
import 'package:kader_nu/pages/user_management_page.dart';
import 'package:kader_nu/widgets/side_menu.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedMenuIndex = 0;

  final List<Widget> _pages = [
    KegiatanPage(),
    JamaahPage(),
    AsetPage(),
    UserManagementPage(),
  ];

  void _onMenuSelected(int index) {
    setState(() {
      _selectedMenuIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userRole = authProvider.role;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: SideMenu(onMenuSelected: _onMenuSelected, role: userRole),
      body: _pages[_selectedMenuIndex],
    );
  }
}
