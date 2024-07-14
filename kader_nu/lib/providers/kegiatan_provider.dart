// lib/providers/kegiatan_provider.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/models/kegiatan_model.dart';
import 'package:kader_nu/services/kegiatan_service.dart';

class KegiatanProvider with ChangeNotifier {
  List<Kegiatan> _kegiatan = [];
  List<Kegiatan> get kegiatan => _kegiatan;

  final KegiatanService kegiatanService = KegiatanService();

  Future<void> fetchKegiatan(String token) async {
    _kegiatan = await kegiatanService.fetchKegiatan(token);
    notifyListeners();
  }

  Future<void> addKegiatan(String token, Kegiatan kegiatan) async {
    Kegiatan newKegiatan = await kegiatanService.addKegiatan(token, kegiatan);
    _kegiatan.add(newKegiatan);
    notifyListeners();
  }

  Future<String> uploadImage(String token, String imagePath) async {
    return await kegiatanService.uploadImage(token, imagePath);
  }
}
