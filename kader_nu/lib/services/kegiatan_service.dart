// lib/services/kegiatan_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kader_nu/models/kegiatan_model.dart';

class KegiatanService {
  final String baseUrl = 'http://localhost:8000/api'; // Ganti dengan URL API Anda

  Future<List<Kegiatan>> fetchKegiatan(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/kegiatan'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Kegiatan> kegiatan = body.map((dynamic item) => Kegiatan.fromJson(item)).toList();
      return kegiatan;
    } else {
      throw Exception('Failed to load kegiatan');
    }
  }

  Future<Kegiatan> addKegiatan(String token, Kegiatan kegiatan) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kegiatan'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(kegiatan.toJson()),
    );

    if (response.statusCode == 201) {
      return Kegiatan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add kegiatan');
    }
  }

  Future<String> uploadImage(String token, String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload-image'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse['imageUrl'];
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
