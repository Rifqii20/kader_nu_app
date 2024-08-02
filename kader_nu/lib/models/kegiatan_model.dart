import 'package:flutter/material.dart';

class Kegiatan {
  int? id;
  String nama;
  String deskripsi;
  DateTime tanggal;

  Kegiatan({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.tanggal,
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}
