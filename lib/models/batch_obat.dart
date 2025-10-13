class Batch {
  final int? idBatch;
  final int idObat;
  final String noBatch;
  final String tglKedaluwarsa;
  final double hargaBeli;
  final double hargaJual;
  final int stokAwal;
  final int stokTersedia;
  final String? namaObat; // relasi dengan tabel obat

  Batch({
    this.idBatch,
    required this.idObat,
    required this.noBatch,
    required this.tglKedaluwarsa,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stokAwal,
    required this.stokTersedia,
    this.namaObat,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      idBatch: int.tryParse(json['id_batch'].toString()),
      idObat: int.parse(json['id_obat'].toString()),
      noBatch: json['no_batch'],
      tglKedaluwarsa: json['tgl_kedaluwarsa'],
      hargaBeli: double.parse(json['harga_beli'].toString()),
      hargaJual: double.parse(json['harga_jual'].toString()),
      stokAwal: int.parse(json['stok_awal'].toString()),
      stokTersedia: int.parse(json['stok_tersedia'].toString()),
      namaObat: json['nama_obat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_batch': idBatch,
      'id_obat': idObat,
      'no_batch': noBatch,
      'tgl_kedaluwarsa': tglKedaluwarsa,
      'harga_beli': hargaBeli,
      'harga_jual': hargaJual,
      'stok_awal': stokAwal,
      'stok_tersedia': stokTersedia,
    };
  }
}
