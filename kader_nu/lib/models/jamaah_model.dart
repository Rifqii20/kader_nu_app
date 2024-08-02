class Jamaah {
  final int? id;
  final String nomorJamaah; // Update sesuai dengan model Laravel
  final String nama;
  final String jabatan;
  final String email;
  final String alamat;
  final String telepon;

  Jamaah({
    required this.id,
    required this.nomorJamaah,
    required this.nama,
    required this.jabatan,
    required this.email,
    required this.alamat,
    required this.telepon,
  });

  factory Jamaah.fromJson(Map<String, dynamic> json) {
    return Jamaah(
      id: json['id'],
      nomorJamaah: json['nomor_jamaah'],
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
      'nomor_jamaah': nomorJamaah,
      'nama': nama,
      'jabatan': jabatan,
      'email': email,
      'alamat': alamat,
      'telepon': telepon,
    };
  }
}
