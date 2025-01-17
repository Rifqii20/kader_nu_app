// lib/models/user_model.dart
class User {
  final int id;
  final String kodeUser;
  final String nama;
  final String email;
  final String role;

  User({
    required this.id,
    required this.kodeUser,
    required this.nama,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      kodeUser: json['kode_user'],
      nama: json['nama'],
      email: json['email'],
      role: json['role'],
    );
  }
}