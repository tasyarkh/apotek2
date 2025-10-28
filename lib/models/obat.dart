class Obat {
  final int? idObat;
  final String namaObat;
  final String bentuk;
  final String? kandungan;
  final String? satuan;
  final String? kategori;
  final int stok; // 🔹 Tambahan baru

  Obat({
    this.idObat,
    required this.namaObat,
    required this.bentuk,
    this.kandungan,
    this.satuan,
    this.kategori,
    this.stok = 0, // 🔹 Default 0 agar aman kalau null
  });

  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      idObat: int.tryParse(json['id_obat'].toString()),
      namaObat: json['nama_obat'] ?? '',
      bentuk: json['bentuk'] ?? '',
      kandungan: json['kandungan']?.toString(),
      satuan: json['satuan']?.toString(),
      kategori: json['kategori']?.toString(),
      stok: int.tryParse(json['stok']?.toString() ?? '0') ?? 0, // ✅ aman dari null
    );
  }

  Map<String, String> toJson() {
    return {
      'id_obat': idObat?.toString() ?? '',
      'nama_obat': namaObat,
      'bentuk': bentuk,
      'kandungan': kandungan ?? '',
      'satuan': satuan ?? '',
      'kategori': kategori ?? '',
      'stok': stok.toString(), // 🔹 kirim juga ke backend (boleh diabaikan di PHP)
    };
  }
}
