class Obat {
  final int? idObat;
  final String namaObat;
  final String bentuk;
  final String kandungan;
  final String satuan;
  final String kategori;

  Obat({
    this.idObat,
    required this.namaObat,
    required this.bentuk,
    required this.kandungan,
    required this.satuan,
    required this.kategori,
  });

  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      idObat: int.tryParse(json['id_obat'].toString()),
      namaObat: json['nama_obat'],
      bentuk: json['bentuk'],
      kandungan: json['kandungan'],
      satuan: json['satuan'],
      kategori: json['kategori'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_obat": idObat,
        "nama_obat": namaObat,
        "bentuk": bentuk,
        "kandungan": kandungan,
        "satuan": satuan,
        "kategori": kategori,
      };
}
