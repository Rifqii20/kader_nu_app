// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/pages/aset/aset_page.dart';
import 'package:kader_nu/pages/jamaah/jamaah_page.dart';
import 'package:kader_nu/pages/kegiatan/kegiatan_page.dart';
import 'package:kader_nu/pages/login_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final role = authProvider.role;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          if (role == 'pcnu' || role == 'mwcnu')
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Jamaah'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => JamaahPage(),
                ),
              );
            },
          ),
          if (role == 'pcnu' || role == 'mwcnu' || role == 'prnu')
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Kegiatan'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => KegiatanPage(),
                  ),
                );
              },
            ),
          if (role == 'pcnu' || role == 'mwcnu')
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Aset'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AsetPage(),
                  ),
                );
              },
            ),
            ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              authProvider.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
