// lib/services/jamaah_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kader_nu/models/jamaah_model.dart';

class JamaahService {
  final String baseUrl = 'http://localhost:8000/api'; // Ganti dengan URL API Anda

  Future<List<Jamaah>> fetchJamaah(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jamaah'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Jamaah> jamaah = body.map((dynamic item) => Jamaah.fromJson(item)).toList();
      return jamaah;
    } else {
      throw Exception('Failed to load jamaah');
    }
  }

  Future<Jamaah> addJamaah(String token, Jamaah jamaah) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jamaah'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jamaah.toJson()),
    );

    if (response.statusCode == 201) {
      return Jamaah.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add jamaah');
    }
  }
}
