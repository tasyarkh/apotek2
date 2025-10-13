class Transaksi {
  int? idTransaksi;
  String tanggal;
  String jenisTransaksi;
  String? namaPelanggan;
  String? kontakPelanggan;
  int idStaff;
  int? idPemasok;

  Transaksi({
    this.idTransaksi,
    required this.tanggal,
    required this.jenisTransaksi,
    this.namaPelanggan,
    this.kontakPelanggan,
    required this.idStaff,
    this.idPemasok,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      idTransaksi: int.tryParse(json['id_transaksi'].toString()),
      tanggal: json['tanggal'],
      jenisTransaksi: json['jenis_transaksi'],
      namaPelanggan: json['nama_pelanggan'],
      kontakPelanggan: json['kontak_pelanggan'],
      idStaff: int.tryParse(json['id_staff'].toString()) ?? 0,
      idPemasok: json['id_pemasok'] != null ? int.tryParse(json['id_pemasok'].toString()) : null,
    );
  }

  Map<String, String> toJson() {
    return {
      'id_transaksi': idTransaksi?.toString() ?? '',
      'tanggal': tanggal,
      'jenis_transaksi': jenisTransaksi,
      'nama_pelanggan': namaPelanggan ?? '',
      'kontak_pelanggan': kontakPelanggan ?? '',
      'id_staff': idStaff.toString(),
      'id_pemasok': idPemasok?.toString() ?? '',
    };
  }
}
