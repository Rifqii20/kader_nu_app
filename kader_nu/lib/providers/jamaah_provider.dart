import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/providers/auth_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:excel/excel.dart';

class JamaahProvider with ChangeNotifier {
  List<Jamaah> _jamaahs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Jamaah> get jamaahs => _jamaahs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchJamaahs(BuildContext context) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/jamaah';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        _jamaahs = data.map((json) => Jamaah.fromJson(json)).toList();
      } else {
        _setError('Failed to load jamaahs');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> addJamaah(BuildContext context, Jamaah jamaah) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/jamaah';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(jamaah.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _jamaahs.add(Jamaah.fromJson(responseData['data']));
      } else {
        _setError('Failed to add jamaah');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateJamaah(BuildContext context, Jamaah jamaah) async {
    _setLoading(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = 'https://kadernu.brandone.my.id/api/jamaah/${jamaah.id}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(jamaah.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final index = _jamaahs.indexWhere((j) => j.id == jamaah.id);
        if (index != -1) {
          _jamaahs[index] = Jamaah.fromJson(responseData['data']);
        }
      } else {
        _setError('Failed to update jamaah');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteJamaah(String token, int id) async {
    _setLoading(true);
    final url = 'https://kadernu.brandone.my.id/api/jamaah/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _jamaahs.removeWhere((jamaah) => jamaah.id == id);
      } else {
        _setError('Failed to delete jamaah');
      }
    } catch (e) {
      _setError('An error occurred');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> exportToExcel(BuildContext context) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Add header row
    sheetObject.appendRow([
      'ID',
      'Nomor Jamaah',
      'Nama',
      'Jabatan',
      'Email',
      'Alamat',
      'Telepon',
    ]);

    // Add data rows
    for (var jamaah in _jamaahs) {
      sheetObject.appendRow([
        jamaah.id,
        jamaah.nomorJamaah,
        jamaah.nama,
        jamaah.jabatan,
        jamaah.email,
        jamaah.alamat,
        jamaah.telepon,
      ]);
    }

    // Save the file
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var directory = await getExternalStorageDirectory();
      String outputFile = "${directory?.path}/jamaah.xlsx";
      var onValue = excel.encode();
      if (onValue != null) {
        File(outputFile)
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data exported successfully to $outputFile'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to encode excel data.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission denied. Unable to save the file.'),
      ));
    }
  }

  String generateNomorJamaah(List<Jamaah> jamaahs) {
    int lastNumber = 0;
    if (jamaahs.isNotEmpty) {
      lastNumber = jamaahs
          .map((jamaah) => int.parse(jamaah.nomorJamaah.substring(1)))
          .reduce((value, element) => value > element ? value : element);
    }
    int newNumber = lastNumber + 1;
    return '0' + newNumber.toString().padLeft(4, '0');
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }
}
