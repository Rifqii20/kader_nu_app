// lib/models/kegiatan_model.dart
class Kegiatan {
  final int id;
  final String nama;
  final String deskripsi;
  final DateTime tanggal;
  final String gambar;

  

  Kegiatan({required this.id, required this.nama, required this.deskripsi, required this.tanggal, required this.gambar});

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      tanggal: DateTime.parse(json['tanggal']),
      gambar: json['gambar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'tanggal': tanggal.toIso8601String(),
      'gambar': gambar,
    };
  }
}
