// lib/models/kegiatan.dart
class Kegiatan {
  final int id;
  final String nama;
  final String deskripsi;
  final DateTime tanggal;

  Kegiatan({
    required this.id,
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
      'deskripsi': deskripsi,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}
