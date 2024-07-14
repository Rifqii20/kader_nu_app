// lib/providers/aset_provider.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/models/aset_model.dart';
import 'package:kader_nu/services/aset_service.dart';

class AsetProvider with ChangeNotifier {
  List<Aset> _aset = [];
  List<Aset> get aset => _aset;

  final AsetService asetService = AsetService();

  Future<void> fetchAset(String token) async {
    _aset = await asetService.fetchAset(token);
    notifyListeners();
  }

  Future<void> addAset(String token, Aset aset) async {
    Aset newAset = await asetService.addAset(token, aset);
    _aset.add(newAset);
    notifyListeners();
  }
}
