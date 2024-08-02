import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/kegiatan_model.dart';
import 'package:kader_nu/providers/kegiatan_provider.dart';

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
  late TextEditingController _tanggalController;

  @override
  void initState() {
    super.initState();
    if (widget.kegiatan != null) {
      _nama = widget.kegiatan!.nama;
      _deskripsi = widget.kegiatan!.deskripsi;
      _tanggal = widget.kegiatan!.tanggal;
    } else {
      _nama = '';
      _deskripsi = '';
      _tanggal = DateTime.now();
    }
    _tanggalController = TextEditingController(text: _tanggal.toIso8601String().split('T').first);
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Kegiatan kegiatan = Kegiatan(
        id: widget.kegiatan?.id,
        nama: _nama,
        deskripsi: _deskripsi,
        tanggal: _tanggal,
      );

      final kegiatanProvider = Provider.of<KegiatanProvider>(context, listen: false);

      try {
        if (widget.kegiatan == null) {
          await kegiatanProvider.addKegiatan(context, kegiatan);
        } else {
          await kegiatanProvider.updateKegiatan(context, kegiatan);
        }
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kegiatan == null ? 'Add Kegiatan' : 'Edit Kegiatan'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _nama,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter nama';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nama = value!;
                },
              ),
              TextFormField(
                initialValue: _deskripsi,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter deskripsi';
                  }
                  return null;
                },
                onSaved: (value) {
                  _deskripsi = value!;
                },
              ),
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(labelText: 'Tanggal'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _tanggal,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _tanggal = pickedDate;
                      _tanggalController.text = _tanggal.toIso8601String().split('T').first;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.kegiatan == null ? 'Add Kegiatan' : 'Update Kegiatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
