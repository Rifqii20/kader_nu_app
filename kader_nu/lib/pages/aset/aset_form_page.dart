// lib/pages/aset_form_page.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/models/aset_model.dart';
import 'package:kader_nu/providers/aset_provider.dart';
import 'package:provider/provider.dart';

class AsetFormPage extends StatefulWidget {
  final Aset? aset;

  AsetFormPage({this.aset});

  @override
  _AsetFormPageState createState() => _AsetFormPageState();
}

class _AsetFormPageState extends State<AsetFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _nama;
  late String _deskripsi;
  late String _lokasi;

  @override
  void initState() {
    super.initState();
    if (widget.aset != null) {
      _nama = widget.aset!.nama;
      _deskripsi = widget.aset!.deskripsi;
      _lokasi = widget.aset!.lokasi;
    } else {
      _nama = '';
      _deskripsi = '';
      _lokasi = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.aset == null ? 'Add Aset' : 'Edit Aset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nama,
                decoration: InputDecoration(labelText: 'Nama'),
                onChanged: (value) => _nama = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _deskripsi,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                onChanged: (value) => _deskripsi = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _lokasi,
                decoration: InputDecoration(labelText: 'Lokasi'),
                onChanged: (value) => _lokasi = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final aset = Aset(
                      id: widget.aset?.id ?? 0,
                      nama: _nama,
                      deskripsi: _deskripsi,
                      lokasi: _lokasi,
                    );

                    if (widget.aset == null) {
                      Provider.of<AsetProvider>(context, listen: false)
                          .addAset(aset)
                          .then((_) => Navigator.of(context).pop());
                    } else {
                      Provider.of<AsetProvider>(context, listen: false)
                          .updateAset(aset)
                          .then((_) => Navigator.of(context).pop());
                    }
                  }
                },
                child: Text(widget.aset == null ? 'Add Aset' : 'Update Aset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
