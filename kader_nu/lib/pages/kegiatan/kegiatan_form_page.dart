// lib/pages/kegiatan_form_page.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/models/kegiatan_model.dart';
import 'package:kader_nu/providers/kegiatan_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class KegiatanFormPage extends StatefulWidget {
  final Kegiatan? kegiatan;

  KegiatanFormPage({this.kegiatan});

  @override
  _KegiatanFormPageState createState() => _KegiatanFormPageState();
}

class _KegiatanFormPageState extends State<KegiatanFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _nama;
  late String _deskripsi;
  late DateTime _tanggal;

  @override
  void initState() {
    super.initState();
    if (widget.kegiatan != null) {
      _nama = widget.kegiatan!.nama;
      _deskripsi = widget.kegiatan!.deskripsi;
      _tanggal = DateTime.parse(widget.kegiatan!.tanggal as String);
    } else {
      _nama = '';
      _deskripsi = '';
      _tanggal = DateTime.now();
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _tanggal) {
      setState(() {
        _tanggal = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kegiatan == null ? 'Add Kegiatan' : 'Edit Kegiatan'),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Tanggal: ${DateFormat('yyyy-MM-dd').format(_tanggal)}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final kegiatan = Kegiatan(
                      id: widget.kegiatan?.id ?? 0,
                      nama: _nama,
                      deskripsi: _deskripsi,
                      tanggal: _tanggal,
                    );

                    if (widget.kegiatan == null) {
                      Provider.of<KegiatanProvider>(context, listen: false)
                          .addKegiatan(kegiatan)
                          .then((_) => Navigator.of(context).pop());
                    } else {
                      Provider.of<KegiatanProvider>(context, listen: false)
                          .updateKegiatan(kegiatan)
                          .then((_) => Navigator.of(context).pop());
                    }
                  }
                },
                child: Text(widget.kegiatan == null ? 'Add Kegiatan' : 'Update Kegiatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
