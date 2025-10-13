class Pemasok {
  final int? idPemasok;
  final String namaPemasok;
  final String alamat;
  final String kontak;

  Pemasok({
    this.idPemasok,
    required this.namaPemasok,
    required this.alamat,
    required this.kontak,
  });

  factory Pemasok.fromJson(Map<String, dynamic> json) {
    return Pemasok(
      idPemasok: int.tryParse(json['id_pemasok'].toString()) ?? 0,
      namaPemasok: json['nama_pemasok'] ?? '',
      alamat: json['alamat'] ?? '',
      kontak: json['kontak'] ?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'id_pemasok': idPemasok?.toString() ?? '',
      'nama_pemasok': namaPemasok,
      'alamat': alamat,
      'kontak': kontak,
    };
  }
}
