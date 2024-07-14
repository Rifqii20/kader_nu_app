// lib/providers/jamaah_provider.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/models/jamaah_model.dart';
import 'package:kader_nu/services/jamaah_service.dart';

class JamaahProvider with ChangeNotifier {
  List<Jamaah> _jamaah = [];
  List<Jamaah> get jamaah => _jamaah;

  final JamaahService jamaahService = JamaahService();

  Future<void> fetchJamaah(String token) async {
    _jamaah = await jamaahService.fetchJamaah(token);
    notifyListeners();
  }

  Future<void> addJamaah(String token, Jamaah jamaah) async {
    Jamaah newJamaah = await jamaahService.addJamaah(token, jamaah);
    _jamaah.add(newJamaah);
    notifyListeners();
  }
}
