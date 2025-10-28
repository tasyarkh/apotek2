import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/obat.dart';
import '../models/batch_obat.dart';
import '../models/pemasok.dart';
import '../models/staff.dart';
import '../models/transaksi.dart';

class ApiService {
  static const String baseUrl = "http://localhost/apotek_apiver2/";

  // =======================================================
  // 🧾 OBAT
  // =======================================================
  static Future<List<Obat>> getObatList() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}obat.php"));
      debugPrint("GET ${baseUrl}obat.php -> ${response.statusCode}");
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Obat.fromJson(e)).toList();
      } else {
        throw Exception("Gagal memuat data obat");
      }
    } catch (e) {
      debugPrint("Error getObatList: $e");
      rethrow;
    }
  }

  static Future<bool> tambahObat(Obat obat) async {
    final response = await http.post(
      Uri.parse("${baseUrl}obat.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(obat.toJson()),
    );
    debugPrint("Response tambah obat: ${response.body}");
    return response.statusCode == 200;
  }

  static Future<bool> updateObat(Obat obat) async {
    final response = await http.put(
      Uri.parse("${baseUrl}obat.php?id=${obat.idObat}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(obat.toJson()),
    );
    debugPrint("Response update obat: ${response.body}");
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
    try {
      final response = await http.get(Uri.parse("${baseUrl}batch_obat.php"));
      debugPrint("GET batch_obat -> ${response.statusCode}");
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Batch.fromJson(e)).toList();
      } else {
        debugPrint("Gagal load batch: ${response.body}");
        throw Exception("Gagal memuat data batch (${response.statusCode})");
      }
    } catch (e) {
      debugPrint("Error getBatchList: $e");
      rethrow;
    }
  }

  static Future<bool> tambahBatch(Batch batch) async {
    try {
      // kirim sebagai JSON biar null bisa terbaca benar oleh PHP
      final response = await http.post(
        Uri.parse("${baseUrl}batch_obat.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(batch.toJson()),
      );

      debugPrint("Response tambahBatch (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error tambahBatch: $e");
      return false;
    }
  }

  static Future<bool> updateBatch(Batch batch) async {
    try {
      final response = await http.put(
        Uri.parse("${baseUrl}batch_obat.php?id=${batch.idBatch}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(batch.toJson()),
      );

      debugPrint("Response updateBatch (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error updateBatch: $e");
      return false;
    }
  }

  static Future<bool> hapusBatch(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("${baseUrl}batch_obat.php?id=$id"),
      );

      debugPrint("Response hapusBatch (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Error hapusBatch: $e");
      return false;
    }
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
    final response = await http.delete(
      Uri.parse("${baseUrl}pemasok.php?id=$id"),
    );
    return response.statusCode == 200;
  }

  // =======================================================
  // 🧾 STAFF
  // =======================================================
  static Future<List<Staff>> getStaffList() async {
    final response = await http.get(Uri.parse("${baseUrl}staff.php"));

    if (response.statusCode == 200) {
      final body = response.body;
      debugPrint("Response staff list: $body");

      try {
        final decoded = json.decode(body);

        // kalau API mengembalikan {"data": [...]} maka ambil key "data"
        final List data = decoded is List ? decoded : (decoded['data'] ?? []);

        return data.map((e) => Staff.fromJson(e)).toList();
      } catch (e) {
        debugPrint("Parsing error staff: $e");
        return [];
      }
    } else {
      throw Exception("Gagal memuat data staff (${response.statusCode})");
    }
  }

  static Future<bool> tambahStaff(Staff staff) async {
    final response = await http.post(
      Uri.parse("${baseUrl}staff.php"),
      body: staff.toJson(),
    );
    debugPrint("Tambah staff response: ${response.body}");

    // tambahkan pengecekan respons agar tidak TypeError
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['success'] == true) {
        return true;
      }
    } catch (_) {}
    return response.statusCode == 200;
  }

  static Future<bool> updateStaff(Staff staff) async {
    final response = await http.put(
      Uri.parse("${baseUrl}staff.php?id=${staff.idStaff}"),
      body: staff.toJson(),
    );
    debugPrint("Update staff response: ${response.body}");

    try {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['success'] == true) {
        return true;
      }
    } catch (_) {}
    return response.statusCode == 200;
  }

  static Future<bool> hapusStaff(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}staff.php?id=$id"));
    debugPrint("Hapus staff response: ${response.body}");

    try {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['success'] == true) {
        return true;
      }
    } catch (_) {}
    return response.statusCode == 200;
  }

  // =======================================================
  // 🧾 TRANSAKSI BARANG KELUAR
  // =======================================================

  // ✅ ambil list transaksi
  static Future<List<Transaksi>> getTransaksiList() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}transaksi.php"));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Transaksi.fromJson(e)).toList();
      } else {
        throw Exception("Gagal memuat transaksi");
      }
    } catch (e) {
      debugPrint("Error getTransaksiList: $e");
      return [];
    }
  }

  // ✅ tambah transaksi utama
  static Future<Map<String, dynamic>?> tambahTransaksiSimple({
    required int idStaff,
    String? keterangan,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}transaksi.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tgl_transaksi': DateTime.now().toIso8601String().split('T')[0],
          'id_staff': idStaff,
          'keterangan': keterangan ?? '',
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Error tambahTransaksiSimple: $e");
    }
    return null;
  }

  // ✅ tambah detail transaksi keluar
  static Future<bool> tambahDetailBarangKeluar({
    required int idTransaksi,
    required int idBatch,
    required int jumlah,
    required double subtotal,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}detail_transaksi.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_transaksi': idTransaksi,
          'id_batch': idBatch,
          'jumlah': jumlah,
          'subtotal': subtotal,
        }),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
    } catch (e) {
      debugPrint("Error tambahDetailBarangKeluar: $e");
    }
    return false;
  }

  // ✅ hapus transaksi
  static Future<bool> hapusTransaksi(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("${baseUrl}transaksi.php?id=$id"),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Error hapusTransaksi: $e");
      return false;
    }
  }

  // ✅ tambah transaksi manual
  static Future<bool> tambahTransaksi(Transaksi trx) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}transaksi.php"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(trx.toJson()),
      );

      debugPrint("Tambah transaksi response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Error tambahTransaksi: $e");
      return false;
    }
  }
}
