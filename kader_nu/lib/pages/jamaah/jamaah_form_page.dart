import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/providers/jamaah_provider.dart';
import 'package:kader_nu/providers/auth_provider.dart';

class JamaahFormPage extends StatefulWidget {
  final Jamaah? jamaah;

  JamaahFormPage({this.jamaah});

  @override
  _JamaahFormPageState createState() => _JamaahFormPageState();
}

class _JamaahFormPageState extends State<JamaahFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _nomorJamaah;
  late String _nama;
  late String _jabatan;
  late String _email;
  late String _alamat;
  late String _telepon;

  @override
  void initState() {
    super.initState();
    if (widget.jamaah != null) {
      _nomorJamaah = widget.jamaah!.nomorJamaah;
      _nama = widget.jamaah!.nama;
      _jabatan = widget.jamaah!.jabatan;
      _email = widget.jamaah!.email;
      _alamat = widget.jamaah!.alamat;
      _telepon = widget.jamaah!.telepon;
    } else {
      _nomorJamaah = '';
      _nama = '';
      _jabatan = '';
      _email = '';
      _alamat = '';
      _telepon = '';
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Jamaah jamaah = Jamaah(
        id: widget.jamaah?.id,
        nomorJamaah: _nomorJamaah,
        nama: _nama,
        jabatan: _jabatan,
        email: _email,
        alamat: _alamat,
        telepon: _telepon,
      );

      final jamaahProvider = Provider.of<JamaahProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        if (widget.jamaah == null) {
          _nomorJamaah = jamaahProvider.generateNomorJamaah(jamaahProvider.jamaahs);
          await jamaahProvider.addJamaah(context, jamaah);
        } else {
          await jamaahProvider.updateJamaah(context, jamaah);
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
        title: Text(widget.jamaah == null ? 'Add Jamaah' : 'Edit Jamaah'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                label: 'Jabatan',
                initialValue: _jabatan,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter jabatan';
                  }
                  return null;
                },
                onSaved: (value) {
                  _jabatan = value!;
                },
              ),
              _buildTextField(
                label: 'Email',
                initialValue: _email,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              _buildTextField(
                label: 'Alamat',
                initialValue: _alamat,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter alamat';
                  }
                  return null;
                },
                onSaved: (value) {
                  _alamat = value!;
                },
              ),
              _buildTextField(
                label: 'Telepon',
                initialValue: _telepon,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter telepon';
                  }
                  return null;
                },
                onSaved: (value) {
                  _telepon = value!;
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
                  widget.jamaah == null ? 'Add Jamaah' : 'Update Jamaah',
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
