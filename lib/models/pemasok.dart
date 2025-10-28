class Pemasok {
  final int? idPemasok;
  final String namaPemasok;
  final String? alamat;
  final String? kontak;

  Pemasok({
    this.idPemasok,
    required this.namaPemasok,
    this.alamat,
    this.kontak,
  });

  factory Pemasok.fromJson(Map<String, dynamic> json) {
    return Pemasok(
      idPemasok: int.tryParse(json['id_pemasok']?.toString() ?? ''),
      namaPemasok: json['nama_pemasok'] ?? '',
      alamat: json['alamat']?.toString(),
      kontak: json['kontak']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pemasok': idPemasok?.toString() ?? '',
      'nama_pemasok': namaPemasok,
      'alamat': alamat ?? '',
      'kontak': kontak ?? '',
    };
  }

  @override
  String toString() => namaPemasok;
}
