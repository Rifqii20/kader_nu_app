import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/providers/jamaah_provider.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'jamaah_form_page.dart';

class JamaahDetailPage extends StatelessWidget {
  final Jamaah jamaah;

  JamaahDetailPage({required this.jamaah});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(jamaah.nama),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JamaahFormPage(jamaah: jamaah),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Jamaah'),
                  content: Text('Are you sure you want to delete this jamaah?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Yes'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await Provider.of<JamaahProvider>(context, listen: false)
                      .deleteJamaah(authProvider.token!, jamaah.id!);
                  Navigator.of(context).pop();
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete jamaah')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Nomor Jamaah', jamaah.nomorJamaah),
                _buildDetailRow('Nama', jamaah.nama),
                _buildDetailRow('Jabatan', jamaah.jabatan),
                _buildDetailRow('Email', jamaah.email),
                _buildDetailRow('Alamat', jamaah.alamat),
                _buildDetailRow('Telepon', jamaah.telepon),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
