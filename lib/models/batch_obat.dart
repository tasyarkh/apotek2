class Batch {
  final int? idBatch;
  final int idObat;
  final int? idPemasok; // boleh null
  final String noBatch;
  final String tglKedaluwarsa;
  final double hargaBeli;
  final double hargaJual;
  final int stokAwal;
  final int stokTersedia;
  final String? namaObat;
  final String? namaPemasok;

  Batch({
    this.idBatch,
    required this.idObat,
    this.idPemasok,
    required this.noBatch,
    required this.tglKedaluwarsa,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stokAwal,
    required this.stokTersedia,
    this.namaObat,
    this.namaPemasok,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      idBatch: json['id_batch'] != null
          ? int.tryParse(json['id_batch'].toString())
          : null,
      idObat: int.tryParse(json['id_obat'].toString()) ?? 0,
      idPemasok: (json['id_pemasok'] == null ||
              json['id_pemasok'].toString().isEmpty)
          ? null
          : int.tryParse(json['id_pemasok'].toString()),
      noBatch: json['no_batch']?.toString() ?? '',
      tglKedaluwarsa: json['tgl_kedaluwarsa']?.toString() ?? '',
      hargaBeli: double.tryParse(json['harga_beli']?.toString() ?? '0') ?? 0.0,
      hargaJual: double.tryParse(json['harga_jual']?.toString() ?? '0') ?? 0.0,
      stokAwal: int.tryParse(json['stok_awal']?.toString() ?? '0') ?? 0,
      stokTersedia: int.tryParse(json['stok_tersedia']?.toString() ?? '0') ?? 0,
      namaObat: json['nama_obat']?.toString(),
      namaPemasok: json['nama_pemasok']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idBatch != null) 'id_batch': idBatch.toString(),
      'id_obat': idObat.toString(),
      // kirim NULL jika tidak ada pemasok
      'id_pemasok': idPemasok == null ? null : idPemasok.toString(),
      'no_batch': noBatch,
      'tgl_kedaluwarsa': tglKedaluwarsa,
      'harga_beli': hargaBeli.toString(),
      'harga_jual': hargaJual.toString(),
      'stok_awal': stokAwal.toString(),
      'stok_tersedia': stokTersedia.toString(),
    };
  }
}
