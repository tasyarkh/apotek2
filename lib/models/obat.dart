class Obat {
  final int? idObat;
  final String namaObat;
  final String bentuk;
  final String? kandungan;
  final String? satuan;
  final String? kategori;

  Obat({
    this.idObat,
    required this.namaObat,
    required this.bentuk,
    this.kandungan,
    this.satuan,
    this.kategori,
  });

  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      idObat: int.tryParse(json['id_obat'].toString()),
      namaObat: json['nama_obat'] ?? '',
      bentuk: json['bentuk'] ?? '',
      kandungan: json['kandungan']?.toString(),
      satuan: json['satuan']?.toString(),
      kategori: json['kategori']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_obat': idObat,
      'nama_obat': namaObat,
      'bentuk': bentuk,
      'kandungan': kandungan ?? '',
      'satuan': satuan ?? '',
      'kategori': kategori ?? '',
    };
  }
}
