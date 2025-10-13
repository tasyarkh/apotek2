class Transaksi {
  final int id;
  final DateTime tanggal;
  final String jenisTransaksi; // 'PEMBELIAN' | 'PENJUALAN' | 'RETUR'
  final String? namaPelanggan;
  final String? kontakPelanggan;
  final int idStaff;
  final int? idPemasok;

  Transaksi({
    required this.id,
    required this.tanggal,
    required this.jenisTransaksi,
    this.namaPelanggan,
    this.kontakPelanggan,
    required this.idStaff,
    this.idPemasok,
  });
}
