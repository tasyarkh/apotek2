import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/obat.dart';
import '../models/batch_obat.dart';
import '../models/pemasok.dart';
import '../models/staff.dart';
import '../models/transaksi.dart';
import '../models/detail_transaksi.dart';


class ApiService {
  static const String baseUrl = "http://10.0.2.2/apotek_apiver2/";

  // =======================================================
  // 🧾 OBAT
  // =======================================================
  static Future<List<Obat>> getObatList() async {
    final response = await http.get(Uri.parse("${baseUrl}obat.php"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Obat.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data obat");
    }
  }

  static Future<bool> tambahObat(Obat obat) async {
    final response = await http.post(
      Uri.parse("${baseUrl}obat.php"),
      body: obat.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateObat(Obat obat) async {
    final response = await http.put(
      Uri.parse("${baseUrl}obat.php?id=${obat.idObat}"),
      body: obat.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> hapusObat(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}obat.php?id=$id"));
    return response.statusCode == 200;
  }

  // =======================================================
  // 🧾 BATCH OBAT
  // =======================================================
  static Future<List<Batch>> getBatchList() async {
    final response = await http.get(Uri.parse("${baseUrl}batch.php"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Batch.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data batch");
    }
  }

  static Future<bool> tambahBatch(Batch batch) async {
    final response = await http.post(
      Uri.parse("${baseUrl}batch.php"),
      body: batch.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateBatch(Batch batch) async {
    final response = await http.put(
      Uri.parse("${baseUrl}batch.php?id=${batch.idBatch}"),
      body: batch.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> hapusBatch(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}batch.php?id=$id"));
    return response.statusCode == 200;
  }

  // =======================================================
  // 🧾 PEMASOK
  // =======================================================
  static Future<List<Pemasok>> getPemasokList() async {
    final response = await http.get(Uri.parse("${baseUrl}pemasok.php"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Pemasok.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data pemasok");
    }
  }

  static Future<bool> tambahPemasok(Pemasok pemasok) async {
    final response = await http.post(
      Uri.parse("${baseUrl}pemasok.php"),
      body: pemasok.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updatePemasok(Pemasok pemasok) async {
    final response = await http.put(
      Uri.parse("${baseUrl}pemasok.php?id=${pemasok.idPemasok}"),
      body: pemasok.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> hapusPemasok(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}pemasok.php?id=$id"));
    return response.statusCode == 200;
  }

  // =======================================================
  // 🧾 STAFF
  // =======================================================
  static Future<List<Staff>> getStaffList() async {
    final response = await http.get(Uri.parse("${baseUrl}staff.php"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Staff.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data staff");
    }
  }

  static Future<bool> tambahStaff(Staff staff) async {
    final response = await http.post(
      Uri.parse("${baseUrl}staff.php"),
      body: staff.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateStaff(Staff staff) async {
    final response = await http.put(
      Uri.parse("${baseUrl}staff.php?id=${staff.idStaff}"),
      body: staff.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> hapusStaff(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}staff.php?id=$id"));
    return response.statusCode == 200;
  }


// =======================================================
// 🧾 TRANSAKSI
// =======================================================
  static Future<List<Transaksi>> getTransaksiList() async {
    final response = await http.get(Uri.parse("${baseUrl}transaksi.php"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Transaksi.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data transaksi");
    }
  }

  static Future<bool> tambahTransaksi(Transaksi trx) async {
    final response = await http.post(
      Uri.parse("${baseUrl}transaksi.php"),
      body: trx.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateTransaksi(Transaksi trx) async {
    final response = await http.put(
      Uri.parse("${baseUrl}transaksi.php?id=${trx.idTransaksi}"),
      body: trx.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> hapusTransaksi(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}transaksi.php?id=$id"));
    return response.statusCode == 200;
  }

// =======================================================
// 🧾 DETAIL TRANSAKSI
// =======================================================
  static Future<List<DetailTransaksi>> getDetailTransaksiList(int idTransaksi) async {
    final response = await http.get(Uri.parse("${baseUrl}detail_transaksi.php?id_transaksi=$idTransaksi"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => DetailTransaksi.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat detail transaksi");
    }
  }

  static Future<bool> tambahDetailTransaksi(DetailTransaksi detail) async {
    final response = await http.post(
      Uri.parse("${baseUrl}detail_transaksi.php"),
      body: detail.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateDetailTransaksi(DetailTransaksi detail) async {
    final response = await http.put(
      Uri.parse("${baseUrl}detail_transaksi.php?id=${detail.idDetail}"),
      body: detail.toJson(),
    );
    return response.statusCode == 200;
  }

  static Future<bool> hapusDetailTransaksi(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}detail_transaksi.php?id=$id"));
    return response.statusCode == 200;
  }

}
