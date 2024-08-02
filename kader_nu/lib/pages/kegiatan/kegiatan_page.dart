import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/kegiatan_model.dart';
import 'package:kader_nu/providers/kegiatan_provider.dart';
import 'package:kader_nu/widgets/app_drawer.dart';
import 'kegiatan_form_page.dart';
import 'kegiatan_detail_page.dart';

class KegiatanPage extends StatefulWidget {
  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KegiatanProvider>(context, listen: false).fetchKegiatan(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kegiatan List',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      drawer: AppDrawer(),
      body: Consumer<KegiatanProvider>(
        builder: (context, kegiatanProvider, child) {
          if (kegiatanProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (kegiatanProvider.errorMessage != null) {
            return Center(child: Text('Error: ${kegiatanProvider.errorMessage}'));
          } else {
            List<Kegiatan> filteredKegiatan = kegiatanProvider.kegiatan.where((kegiatan) {
              return kegiatan.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     kegiatan.deskripsi.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredKegiatan.length,
              itemBuilder: (context, index) {
                final kegiatan = filteredKegiatan[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      kegiatan.nama,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(kegiatan.deskripsi),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => KegiatanDetailPage(kegiatan: kegiatan),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KegiatanFormPage(),
          ),
        ),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }
}
