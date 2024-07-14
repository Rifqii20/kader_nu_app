// lib/models/jamaah_model.dart
class Jamaah {
  final int id;
  final String nama;
  final String jabatan;
  final String email;
  final String alamat;
  final String telepon;

  Jamaah({required this.id, required this.nama, required this.jabatan, required this.email, required this.alamat, required this.telepon});

  factory Jamaah.fromJson(Map<String, dynamic> json) {
    return Jamaah(
      id: json['id'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      email: json['email'],
      alamat: json['alamat'],
      telepon: json['telepon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jabatan': jabatan,
      'email': email,
      'alamat': alamat,
      'nomor_telepon': telepon,
    };
  }
}
