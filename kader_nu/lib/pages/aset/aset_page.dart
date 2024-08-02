import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/aset_model.dart';
import 'package:kader_nu/providers/aset_provider.dart';
import 'package:kader_nu/widgets/app_drawer.dart';
import 'aset_form_page.dart';
import 'aset_detail_page.dart';

class AsetPage extends StatefulWidget {
  @override
  _AsetPageState createState() => _AsetPageState();
}

class _AsetPageState extends State<AsetPage> {
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
      Provider.of<AsetProvider>(context, listen: false).fetchAset(context);
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
          'Aset List',
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
      body: Consumer<AsetProvider>(
        builder: (context, asetProvider, child) {
          if (asetProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (asetProvider.errorMessage != null) {
            return Center(child: Text('Error: ${asetProvider.errorMessage}'));
          } else {
            List<Aset> filteredAset = asetProvider.aset.where((aset) {
              return aset.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     aset.deskripsi.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredAset.length,
              itemBuilder: (context, index) {
                final aset = filteredAset[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      aset.nama,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(aset.deskripsi),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AsetDetailPage(aset: aset),
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
            builder: (context) => AsetFormPage(),
          ),
        ),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }
}
