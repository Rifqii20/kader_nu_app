// lib/providers/kegiatan_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kader_nu/models/kegiatan_model.dart';

class KegiatanProvider with ChangeNotifier {
  List<Kegiatan> _kegiatan = [];

  List<Kegiatan> get kegiatan => _kegiatan;

  Future<void> fetchKegiatan() async {
    const url = 'https://kadernu.brandone.my.id/api/kegiatan';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _kegiatan = data.map((json) => Kegiatan.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load kegiatan');
    }
  }

  Future<void> addKegiatan(Kegiatan kegiatan) async {
    const url = 'https://kadernu.brandone.my.id/api/kegiatan';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(kegiatan.toJson()),
    );

    if (response.statusCode == 201) {
      _kegiatan.add(Kegiatan.fromJson(json.decode(response.body)));
      notifyListeners();
    } else {
      throw Exception('Failed to add kegiatan');
    }
  }

  Future<void> updateKegiatan(Kegiatan kegiatan) async {
    final url = 'https://kadernu.brandone.my.id/api/kegiatan/${kegiatan.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(kegiatan.toJson()),
    );

    if (response.statusCode == 200) {
      final index = _kegiatan.indexWhere((k) => k.id == kegiatan.id);
      if (index != -1) {
        _kegiatan[index] = Kegiatan.fromJson(json.decode(response.body));
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update kegiatan');
    }
  }

  Future<void> deleteKegiatan(int id) async {
    final url = 'https://kadernu.brandone.my.id/api/kegiatan/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      _kegiatan.removeWhere((kegiatan) => kegiatan.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete kegiatan');
    }
  }
}
