// lib/models/aset_model.dart
class Aset {
  final int id;
  final String nama;
  final String deskripsi;
  final String kodeAset;
  final String lokasi;

  Aset({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.kodeAset,
    required this.lokasi,
  });

  factory Aset.fromJson(Map<String, dynamic> json) {
    return Aset(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      kodeAset: json['kode_aset'],
      lokasi: json['lokasi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'kode_aset': kodeAset,
      'lokasi': lokasi,
    };
  }
}
