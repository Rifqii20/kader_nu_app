import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/providers/jamaah_provider.dart';
import 'package:kader_nu/widgets/app_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'jamaah_form_page.dart';
import 'jamaah_detail_page.dart';

class JamaahPage extends StatefulWidget {
  @override
  _JamaahPageState createState() => _JamaahPageState();
}

class _JamaahPageState extends State<JamaahPage> {
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
      Provider.of<JamaahProvider>(context, listen: false).fetchJamaahs(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // Permission is granted
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is required to export to Excel')),
      );
    }
  }

  Future<void> _exportToExcel(List<Jamaah> jamaahs) async {
    await _requestPermissions();

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Jamaah'];
    sheetObject.appendRow(['Nomor Jamaah', 'Nama', 'Jabatan', 'Email', 'Alamat', 'Telepon']);

    for (var jamaah in jamaahs) {
      sheetObject.appendRow([
        jamaah.nomorJamaah,
        jamaah.nama,
        jamaah.jabatan,
        jamaah.email,
        jamaah.alamat,
        jamaah.telepon,
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/jamaah.xlsx";
    var fileBytes = excel.save();
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exported to $path')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jamaah List',
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
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              final jamaahProvider = Provider.of<JamaahProvider>(context, listen: false);
              _exportToExcel(jamaahProvider.jamaahs);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Consumer<JamaahProvider>(
        builder: (context, jamaahProvider, child) {
          if (jamaahProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (jamaahProvider.errorMessage != null) {
            return Center(child: Text('Error: ${jamaahProvider.errorMessage}'));
          } else {
            List<Jamaah> filteredJamaahs = jamaahProvider.jamaahs.where((jamaah) {
              return jamaah.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     jamaah.jabatan.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredJamaahs.length,
              itemBuilder: (context, index) {
                final jamaah = filteredJamaahs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      jamaah.nama,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(jamaah.jabatan),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => JamaahDetailPage(jamaah: jamaah),
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
            builder: (context) => JamaahFormPage(),
          ),
        ),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }
}
