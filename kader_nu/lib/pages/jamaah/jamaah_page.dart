import 'package:flutter/material.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/providers/jamaah_provider.dart';
import 'package:kader_nu/utils/export_to_excel.dart';
import 'package:kader_nu/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'jamaah_form_page.dart';
import 'jamaah_detail_page.dart';

class JamaahPage extends StatefulWidget {
  @override
  _JamaahPageState createState() => _JamaahPageState();
}

class _JamaahPageState extends State<JamaahPage> {
  late Future<List<Jamaah>> futureJamaah;
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
    Provider.of<JamaahProvider>(context, listen: false).fetchJamaahs();
  }

  Future<void> _exportToExcel() async {
    final jamaahProvider = Provider.of<JamaahProvider>(context, listen: false);
    await exportJamaahsToExcel(jamaahProvider.jamaahs);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data exported to Excel successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jamaah List'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _exportToExcel,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Consumer<JamaahProvider>(
        builder: (context, jamaahProvider, child) {
          return FutureBuilder(
            future: jamaahProvider.fetchJamaahs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Jamaah> filteredJamaahs = jamaahProvider.jamaahs.where((jamaah) {
                  return jamaah.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                         jamaah.jabatan.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();
                
                return ListView.builder(
                  itemCount: filteredJamaahs.length,
                  itemBuilder: (context, index) {
                    final jamaah = filteredJamaahs[index];
                    return ListTile(
                      title: Text(jamaah.nama),
                      subtitle: Text(jamaah.jabatan),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => JamaahDetailPage(jamaah: jamaah),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JamaahFormPage(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
