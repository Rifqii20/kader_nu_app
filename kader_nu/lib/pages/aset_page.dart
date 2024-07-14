// lib/pages/aset_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/aset_model.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:kader_nu/providers/aset_provider.dart';

class AsetPage extends StatefulWidget {
  @override
  _AsetPageState createState() => _AsetPageState();
}

class _AsetPageState extends State<AsetPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController kodeAsetController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final asetProvider = Provider.of<AsetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Aset'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: asetProvider.fetchAset(authProvider.token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: asetProvider.aset.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(asetProvider.aset[index].nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(asetProvider.aset[index].deskripsi),
                              Text('Kode Aset: ${asetProvider.aset[index].kodeAset}'),
                              Text('Lokasi: ${asetProvider.aset[index].lokasi}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(labelText: 'Nama Aset'),
                ),
                TextField(
                  controller: deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                ),
                TextField(
                  controller: kodeAsetController,
                  decoration: InputDecoration(labelText: 'Kode Aset'),
                ),
                TextField(
                  controller: lokasiController,
                  decoration: InputDecoration(labelText: 'Lokasi'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String nama = namaController.text;
                    String deskripsi = deskripsiController.text;
                    String kodeAset = kodeAsetController.text;
                    String lokasi = lokasiController.text;// Handle image upload separately

                    Aset aset = Aset(
                      id: 0,
                      nama: nama,
                      deskripsi: deskripsi,
                      kodeAset: kodeAset,
                      lokasi: lokasi,
                    );

                    await asetProvider.addAset(authProvider.token, aset);

                    namaController.clear();
                    deskripsiController.clear();
                    kodeAsetController.clear();
                    lokasiController.clear();
                  },
                  child: Text('Tambah Aset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
