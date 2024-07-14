// lib/pages/jamaah_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:kader_nu/providers/jamaah_provider.dart';

class JamaahPage extends StatefulWidget {
  @override
  _JamaahPageState createState() => _JamaahPageState();
}

class _JamaahPageState extends State<JamaahPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jabatanController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final jamaahProvider = Provider.of<JamaahProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Jamaah'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: jamaahProvider.fetchJamaah(authProvider.token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: jamaahProvider.jamaah.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(jamaahProvider.jamaah[index].nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(jamaahProvider.jamaah[index].jabatan),
                              Text(jamaahProvider.jamaah[index].email),
                              Text(jamaahProvider.jamaah[index].alamat),
                              Text(jamaahProvider.jamaah[index].telepon),
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
                  decoration: InputDecoration(labelText: 'Nama Jamaah'),
                ),
                TextField(
                  controller: jabatanController,
                  decoration: InputDecoration(labelText: 'Jabatan'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: alamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                ),
                TextField(
                  controller: teleponController,
                  decoration: InputDecoration(labelText: 'Nomor Telepon'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String nama = namaController.text;
                    String jabatan = jabatanController.text;
                    String email = emailController.text;
                    String alamat = alamatController.text;
                    String telepon = teleponController.text;

                    Jamaah jamaah = Jamaah(
                      id: 0,
                      nama: nama,
                      jabatan: jabatan,
                      email: email,
                      alamat: alamat,
                      telepon: telepon,
                    );

                    await jamaahProvider.addJamaah(authProvider.token, jamaah);

                    namaController.clear();
                    alamatController.clear();
                    teleponController.clear();
                  },
                  child: Text('Tambah Jamaah'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
