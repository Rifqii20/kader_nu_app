// lib/providers/aset_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kader_nu/models/aset_model.dart';


class AsetProvider with ChangeNotifier {
  List<Aset> _aset = [];

  List<Aset> get aset => _aset;

  Future<void> fetchAset() async {
    final url = 'https://kadernu.brandone.my.id/api/aset';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _aset = data.map((json) => Aset.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load aset');
    }
  }

  Future<void> addAset(Aset aset) async {
    final url = 'https://kadernu.brandone.my.id/api/aset';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(aset.toJson()),
    );

    if (response.statusCode == 201) {
      _aset.add(Aset.fromJson(json.decode(response.body)));
      notifyListeners();
    } else {
      throw Exception('Failed to add aset');
    }
  }

  Future<void> updateAset(Aset aset) async {
    final url = 'https://kadernu.brandone.my.id/api/aset/${aset.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(aset.toJson()),
    );

    if (response.statusCode == 200) {
      final index = _aset.indexWhere((a) => a.id == aset.id);
      if (index != -1) {
        _aset[index] = Aset.fromJson(json.decode(response.body));
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update aset');
    }
  }

  Future<void> deleteAset(int id) async {
    final url = 'http://your-laravel-api-url/api/aset/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      _aset.removeWhere((aset) => aset.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete aset');
    }
  }
}
