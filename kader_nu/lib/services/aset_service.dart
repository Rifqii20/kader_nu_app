// lib/services/aset_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kader_nu/models/aset_model.dart';

class AsetService {
  final String baseUrl = 'http://localhost:8000/api'; // Ganti dengan URL API Anda

  Future<List<Aset>> fetchAset(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/aset'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Aset> aset = body.map((dynamic item) => Aset.fromJson(item)).toList();
      return aset;
    } else {
      throw Exception('Failed to load aset');
    }
  }

  Future<Aset> addAset(String token, Aset aset) async {
    final response = await http.post(
      Uri.parse('$baseUrl/aset'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(aset.toJson()),
    );

    if (response.statusCode == 201) {
      return Aset.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add aset');
    }
  }
}
