import 'package:flutter/material.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/pages/jamaah/jamaah_form_page.dart';
import 'package:kader_nu/providers/jamaah_provider.dart';
import 'package:provider/provider.dart';


class JamaahDetailPage extends StatelessWidget {
  final Jamaah jamaah;

  JamaahDetailPage({required this.jamaah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jamaah.nama),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${jamaah.nama}'),
            Text('Jabatan: ${jamaah.jabatan}'),
            Text('Email: ${jamaah.email}'),
            Text('Alamat: ${jamaah.alamat}'),
            Text('Telepon: ${jamaah.telepon}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JamaahFormPage(jamaah: jamaah),
                ),
              ),
              child: Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool confirmed = await _showConfirmationDialog(context);
                if (confirmed) {
                  await Provider.of<JamaahProvider>(context, listen: false).deleteJamaah(jamaah.id);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
