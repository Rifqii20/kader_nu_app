// lib/pages/kegiatan_page.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/models/kegiatan_model.dart';
import 'package:kader_nu/providers/kegiatan_provider.dart';
import 'package:kader_nu/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'kegiatan_detail_page.dart';
import 'kegiatan_form_page.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class KegiatanPage extends StatefulWidget {
  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  late List<Kegiatan> _kegiatanList;
  List<Kegiatan> _filteredKegiatanList = [];

  @override
  void initState() {
    super.initState();
    _fetchKegiatan();
  }

  Future<void> _fetchKegiatan() async {
    try {
      final kegiatanProvider = Provider.of<KegiatanProvider>(context, listen: false);
      await kegiatanProvider.fetchKegiatan();
      setState(() {
        _kegiatanList = kegiatanProvider.kegiatan;
        _filteredKegiatanList = _kegiatanList;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load kegiatan')));
    }
  }

  void _searchKegiatan(String query) {
    final filteredList = _kegiatanList.where((kegiatan) {
      final nameLower = kegiatan.nama.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();
    setState(() {
      _filteredKegiatanList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kegiatan'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => KegiatanFormPage(),
                ),
              ).then((_) => _fetchKegiatan());
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchKegiatan,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredKegiatanList.length,
              itemBuilder: (context, index) {
                final kegiatan = _filteredKegiatanList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(kegiatan.nama),
                    subtitle: Text(
                      '${kegiatan.deskripsi}\n${DateFormat('yyyy-MM-dd').format(DateTime.parse(kegiatan.tanggal as String))}',
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => KegiatanDetailPage(kegiatan: kegiatan),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
