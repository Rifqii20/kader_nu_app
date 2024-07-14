// lib/widgets/side_menu.dart
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Function(int) onMenuSelected;
  final String role;

  SideMenu({required this.onMenuSelected, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Dashboard Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Kegiatan'),
            onTap: () {
              onMenuSelected(0);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Jamaah'),
            onTap: () {
              onMenuSelected(1);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Aset'),
            onTap: () {
              onMenuSelected(2);
              Navigator.of(context).pop();
            },
          ),
          if (role == 'pcnu') // Conditional rendering based on role
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('User Management'),
              onTap: () {
                onMenuSelected(3);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
