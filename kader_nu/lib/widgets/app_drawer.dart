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
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              'User Name',
              style: TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              authProvider.token != null ? 'Logged in' : 'Not logged in',
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
          if (role == 'pcnu' || role == 'mwcnu')
            _createDrawerItem(
              icon: Icons.group,
              text: 'Jamaah',
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => JamaahPage(),
                  ),
                );
              },
            ),
          if (role == 'pcnu' || role == 'mwcnu' || role == 'prnu')
            _createDrawerItem(
              icon: Icons.event,
              text: 'Kegiatan',
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => KegiatanPage(),
                  ),
                );
              },
            ),
          if (role == 'pcnu' || role == 'mwcnu')
            _createDrawerItem(
              icon: Icons.business,
              text: 'Aset',
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AsetPage(),
                  ),
                );
              },
            ),
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
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

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: Colors.blueAccent),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
