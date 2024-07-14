// lib/pages/kegiatan_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kader_nu/models/kegiatan_model.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:kader_nu/providers/kegiatan_provider.dart';
import 'dart:io';

class KegiatanPage extends StatefulWidget {
  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final kegiatanProvider = Provider.of<KegiatanProvider>(context);

    Future<void> pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (image != null) {
          _image = File(image.path);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kegiatan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: kegiatanProvider.fetchKegiatan(authProvider.token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: kegiatanProvider.kegiatan.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: kegiatanProvider.kegiatan[index].gambar.isNotEmpty
                            ? Image.network(kegiatanProvider.kegiatan[index].gambar)
                            : null,
                        title: Text(kegiatanProvider.kegiatan[index].nama),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(kegiatanProvider.kegiatan[index].deskripsi),
                            Text(DateFormat.yMMMd().format(kegiatanProvider.kegiatan[index].tanggal)),
                          ],
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
                  decoration: InputDecoration(labelText: 'Nama Kegiatan'),
                ),
                TextField(
                  controller: deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                ),
                TextField(
                  controller: tanggalController,
                  decoration: InputDecoration(labelText: 'Tanggal (yyyy-mm-dd)'),
                ),
                SizedBox(height: 10),
                _image == null
                    ? Text('No image selected.')
                    : Image.file(_image!),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text('Pilih Gambar'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image')));
                      return;
                    }

                    String nama = namaController.text;
                    String deskripsi = deskripsiController.text;
                    DateTime tanggal = DateTime.parse(tanggalController.text);

                    // Upload image first
                    String imageUrl = await kegiatanProvider.uploadImage(authProvider.token, _image!.path);

                    // Then create kegiatan
                    Kegiatan kegiatan = Kegiatan(id: 0, nama: nama, deskripsi: deskripsi, tanggal: tanggal, gambar: imageUrl);
                    await kegiatanProvider.addKegiatan(authProvider.token, kegiatan);

                    namaController.clear();
                    deskripsiController.clear();
                    tanggalController.clear();
                    setState(() {
                      _image = null;
                    });
                  },
                  child: Text('Tambah Kegiatan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
