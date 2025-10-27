class Staff {
  int? idStaff;
  String namaStaff;
  String username;
  String password;

  Staff({
    this.idStaff,
    required this.namaStaff,
    required this.username,
    required this.password,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      idStaff: int.tryParse(json['id_staff']?.toString() ?? '0'),
      namaStaff: json['nama_staff']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'id_staff': idStaff?.toString() ?? '',
      'nama_staff': namaStaff,
      'username': username,
      'password': password,
    };
  }
}
