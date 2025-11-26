<?php
include 'db.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// 🔹 Handle preflight request (CORS)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {

  // ======================================
  // 🔹 GET - Ambil semua data obat
  // ======================================
  case 'GET':
    $result = $conn->query("SELECT id_obat, nama_obat, bentuk, kandungan, satuan, kategori, stok FROM obat ORDER BY id_obat DESC");
    $data = [];
    while ($row = $result->fetch_assoc()) {
      $data[] = $row;
    }
    echo json_encode($data);
    break;

  // ======================================
  // 🔹 POST - Tambah data obat baru
  // ======================================
  case 'POST':
    $input = json_decode(file_get_contents('php://input'), true);

    $nama = $input['nama_obat'] ?? '';
    $bentuk = $input['bentuk'] ?? '';
    $kandungan = $input['kandungan'] ?? '';
    $satuan = $input['satuan'] ?? '';
    $kategori = $input['kategori'] ?? '';

    $sql = "INSERT INTO obat (nama_obat, bentuk, kandungan, satuan, kategori, stok)
            VALUES ('$nama', '$bentuk', '$kandungan', '$satuan', '$kategori', 0)";
    $result = $conn->query($sql);

    echo json_encode([
      "success" => $result ? true : false,
      "message" => $result ? "Obat berhasil ditambahkan" : "Gagal menambah obat",
      "error" => $result ? null : $conn->error
    ]);
    break;

  // ======================================
  // 🔹 PUT - Update data obat
  // ======================================
  case 'PUT':
    $input = json_decode(file_get_contents('php://input'), true);

    $id = $input['id_obat'] ?? null;
    if (!$id) {
      echo json_encode(["success" => false, "message" => "ID obat tidak ditemukan"]);
      exit;
    }

    $nama = $input['nama_obat'] ?? '';
    $bentuk = $input['bentuk'] ?? '';
    $kandungan = $input['kandungan'] ?? '';
    $satuan = $input['satuan'] ?? '';
    $kategori = $input['kategori'] ?? '';

    $sql = "UPDATE obat SET 
              nama_obat='$nama', 
              bentuk='$bentuk', 
              kandungan='$kandungan',
              satuan='$satuan', 
              kategori='$kategori'
            WHERE id_obat=$id";
    $result = $conn->query($sql);

    echo json_encode([
      "success" => $result ? true : false,
      "message" => $result ? "Obat berhasil diperbarui" : "Gagal memperbarui obat",
      "error" => $result ? null : $conn->error
    ]);
    break;

  // ======================================
  // 🔹 DELETE - Hapus data obat
  // ======================================
  case 'DELETE':
    $id = $_GET['id_obat'] ?? null;
    if (!$id) {
      echo json_encode(["success" => false, "message" => "ID tidak ditemukan"]);
      exit;
    }

    $sql = "DELETE FROM obat WHERE id_obat=$id";
    $result = $conn->query($sql);

    echo json_encode([
      "success" => $result ? true : false,
      "message" => $result ? "Obat berhasil dihapus" : "Gagal menghapus obat",
      "error" => $result ? null : $conn->error
    ]);
    break;

  default:
    echo json_encode(["success" => false, "message" => "Metode tidak dikenali"]);
    break;
}

$conn->close();
?>
