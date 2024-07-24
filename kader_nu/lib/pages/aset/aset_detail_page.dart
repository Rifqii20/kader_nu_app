// lib/pages/aset_detail_page.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/models/aset_model.dart';
import 'package:kader_nu/pages/aset/aset_form_page.dart';
import 'package:kader_nu/providers/aset_provider.dart';
import 'package:provider/provider.dart';

class AsetDetailPage extends StatelessWidget {
  final Aset aset;

  AsetDetailPage({required this.aset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Aset'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AsetFormPage(aset: aset),
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
                  content: Text('Are you sure you want to delete this aset?'),
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
                  await Provider.of<AsetProvider>(context, listen: false).deleteAset(aset.id);
                  Navigator.of(context).pop();
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete aset')));
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
            Text('Nama: ${aset.nama}', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            Text('Deskripsi: ${aset.deskripsi}', style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text('Lokasi: ${aset.lokasi}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
