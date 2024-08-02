import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/aset_model.dart';
import 'package:kader_nu/providers/aset_provider.dart';
import 'package:kader_nu/providers/auth_provider.dart';

class AsetFormPage extends StatefulWidget {
  final Aset? aset;

  AsetFormPage({this.aset});

  @override
  _AsetFormPageState createState() => _AsetFormPageState();
}

class _AsetFormPageState extends State<AsetFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _kodeAset;
  late String _nama;
  late String _deskripsi;
  late String _lokasi;

  @override
  void initState() {
    super.initState();
    if (widget.aset != null) {
      _kodeAset = widget.aset!.kodeAset;
      _nama = widget.aset!.nama;
      _deskripsi = widget.aset!.deskripsi;
      _lokasi = widget.aset!.lokasi;
    } else {
      _kodeAset = '';
      _nama = '';
      _deskripsi = '';
      _lokasi = '';
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final asetProvider = Provider.of<AsetProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      Aset aset = Aset(
        id: widget.aset?.id,
        kodeAset: widget.aset?.kodeAset ?? asetProvider.generateKodeAset(asetProvider.aset),
        nama: _nama,
        deskripsi: _deskripsi,
        lokasi: _lokasi,
      );

      try {
        if (widget.aset == null) {
          await asetProvider.addAset(context, aset);
        } else {
          await asetProvider.updateAset(context, aset);
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
        title: Text(widget.aset == null ? 'Add Aset' : 'Edit Aset'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.aset == null) 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Kode Aset: ${Provider.of<AsetProvider>(context).generateKodeAset(Provider.of<AsetProvider>(context).aset)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              _buildTextField(
                label: 'Nama',
                initialValue: _nama,
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
              _buildTextField(
                label: 'Deskripsi',
                initialValue: _deskripsi,
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
              _buildTextField(
                label: 'Lokasi',
                initialValue: _lokasi,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter lokasi';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lokasi = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  widget.aset == null ? 'Add Aset' : 'Update Aset',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
