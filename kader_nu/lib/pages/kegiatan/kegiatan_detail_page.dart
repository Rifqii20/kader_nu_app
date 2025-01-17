import 'package:flutter/material.dart';
import 'package:kader_nu/models/kegiatan_model.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:kader_nu/providers/kegiatan_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'kegiatan_form_page.dart';

class KegiatanDetailPage extends StatelessWidget {
  final Kegiatan kegiatan;

  KegiatanDetailPage({required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(kegiatan.nama),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => KegiatanFormPage(kegiatan: kegiatan),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirm Delete'),
                  content: Text('Are you sure you want to delete this kegiatan?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text('Delete'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                try {
                  await Provider.of<KegiatanProvider>(context, listen: false)
                      .deleteKegiatan(authProvider.token!, kegiatan.id!);
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Nama: ${kegiatan.nama}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Deskripsi: ${kegiatan.deskripsi}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Tanggal: ${DateFormat('yyyy-MM-dd').format(kegiatan.tanggal)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
