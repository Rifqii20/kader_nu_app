import 'package:flutter/material.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/providers/jamaah_provider.dart';
import 'package:provider/provider.dart';


class JamaahFormPage extends StatefulWidget {
  final Jamaah? jamaah;

  JamaahFormPage({this.jamaah});

  @override
  _JamaahFormPageState createState() => _JamaahFormPageState();
}

class _JamaahFormPageState extends State<JamaahFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _jabatanController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;
  late TextEditingController _teleponController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.jamaah?.nama ?? '');
    _jabatanController = TextEditingController(text: widget.jamaah?.jabatan ?? '');
    _emailController = TextEditingController(text: widget.jamaah?.email ?? '');
    _alamatController = TextEditingController(text: widget.jamaah?.alamat ?? '');
    _teleponController = TextEditingController(text: widget.jamaah?.telepon ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jabatanController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jamaah == null ? 'Add Jamaah' : 'Edit Jamaah'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter nama';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jabatanController,
                decoration: InputDecoration(labelText: 'Jabatan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter jabatan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter alamat';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _teleponController,
                decoration: InputDecoration(labelText: 'Telepon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter telepon';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final jamaah = Jamaah(
                      id: widget.jamaah?.id ?? 0,
                      nama: _namaController.text,
                      jabatan: _jabatanController.text,
                      email: _emailController.text,
                      alamat: _alamatController.text,
                      telepon: _teleponController.text,
                    );
                    if (widget.jamaah == null) {
                      await Provider.of<JamaahProvider>(context, listen: false).addJamaah(jamaah);
                    } else {
                      await Provider.of<JamaahProvider>(context, listen: false).updateJamaah(jamaah);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.jamaah == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
