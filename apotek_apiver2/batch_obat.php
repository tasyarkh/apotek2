<?php
include 'db.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight request (CORS)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {

    // ==================================================
    // 🔹 GET: Ambil semua batch atau 1 batch by ID
    // ==================================================
    case 'GET':
        if (isset($_GET['id_batch'])) {
            $id = intval($_GET['id_batch']);
            $query = "
                SELECT b.*, o.nama_obat, p.nama_pemasok
                FROM batch_obat b
                JOIN obat o ON b.id_obat = o.id_obat
                LEFT JOIN pemasok p ON b.id_pemasok = p.id_pemasok
                WHERE b.id_batch = $id
            ";
            $result = mysqli_query($conn, $query);
            $data = mysqli_fetch_assoc($result);
            echo json_encode($data ?: []);
        } else {
            $query = "
                SELECT b.*, o.nama_obat, p.nama_pemasok
                FROM batch_obat b
                JOIN obat o ON b.id_obat = o.id_obat
                LEFT JOIN pemasok p ON b.id_pemasok = p.id_pemasok
                ORDER BY b.id_batch DESC
            ";
            $result = mysqli_query($conn, $query);
            $data = [];
            while ($row = mysqli_fetch_assoc($result)) {
                $data[] = $row;
            }
            echo json_encode($data);
        }
        break;

    // ==================================================
    // 🔹 POST: Tambah batch baru
    // ==================================================
    case 'POST':
        $input = json_decode(file_get_contents("php://input"), true);

        if (!$input) {
            echo json_encode(['success' => false, 'message' => 'Input JSON tidak valid']);
            exit;
        }

        $id_obat = $input['id_obat'] ?? null;
        $id_pemasok = $input['id_pemasok'] ?? null;
        $no_batch = $input['no_batch'] ?? '';
        $tgl_kedaluwarsa = $input['tgl_kedaluwarsa'] ?? '';
        $harga_beli = $input['harga_beli'] ?? 0;
        $harga_jual = $input['harga_jual'] ?? 0;
        $stok_awal = $input['stok_awal'] ?? 0;
        $stok_tersedia = $input['stok_tersedia'] ?? 0;

        if (!$id_obat || empty($no_batch)) {
            echo json_encode(['success' => false, 'message' => 'Data tidak lengkap (id_obat / no_batch kosong)']);
            exit;
        }

        $query = "
            INSERT INTO batch_obat 
            (id_obat, id_pemasok, no_batch, tgl_kedaluwarsa, harga_beli, harga_jual, stok_awal, stok_tersedia)
            VALUES 
            ('$id_obat', " . ($id_pemasok ? "'$id_pemasok'" : "NULL") . ",
             '$no_batch', '$tgl_kedaluwarsa', '$harga_beli', '$harga_jual', '$stok_awal', '$stok_tersedia')
        ";

        $result = mysqli_query($conn, $query);

        echo json_encode([
            'success' => (bool)$result,
            'message' => $result ? '✅ Data batch berhasil ditambahkan' : '❌ Gagal menambah data',
            'error' => $result ? null : mysqli_error($conn),
            'query' => $query
        ]);
        break;

    // ==================================================
    // 🔹 PUT: Update batch
    // ==================================================
    case 'PUT':
        $input = json_decode(file_get_contents("php://input"), true);

        if (!$input) {
            echo json_encode(['success' => false, 'message' => 'Input JSON tidak valid']);
            exit;
        }

        $id_batch = $input['id_batch'] ?? null;
        if (!$id_batch) {
            echo json_encode(['success' => false, 'message' => 'ID batch tidak ditemukan']);
            exit;
        }

        $id_obat = $input['id_obat'] ?? null;
        $id_pemasok = $input['id_pemasok'] ?? null;
        $no_batch = $input['no_batch'] ?? '';
        $tgl_kedaluwarsa = $input['tgl_kedaluwarsa'] ?? '';
        $harga_beli = $input['harga_beli'] ?? 0;
        $harga_jual = $input['harga_jual'] ?? 0;
        $stok_awal = $input['stok_awal'] ?? 0;
        $stok_tersedia = $input['stok_tersedia'] ?? 0;

        $query = "
            UPDATE batch_obat SET
                id_obat = '$id_obat',
                id_pemasok = " . ($id_pemasok ? "'$id_pemasok'" : "NULL") . ",
                no_batch = '$no_batch',
                tgl_kedaluwarsa = '$tgl_kedaluwarsa',
                harga_beli = '$harga_beli',
                harga_jual = '$harga_jual',
                stok_awal = '$stok_awal',
                stok_tersedia = '$stok_tersedia'
            WHERE id_batch = '$id_batch'
        ";

        $result = mysqli_query($conn, $query);

        echo json_encode([
            'success' => (bool)$result,
            'message' => $result ? '✅ Data batch berhasil diperbarui' : '❌ Gagal memperbarui data',
            'error' => $result ? null : mysqli_error($conn),
            'query' => $query
        ]);
        break;

    // ==================================================
    // 🔹 DELETE: Hapus batch
    // ==================================================
    case 'DELETE':
        $id = $_GET['id'] ?? null;
        if (!$id) {
            echo json_encode(['success' => false, 'message' => 'ID batch tidak ditemukan']);
            exit;
        }

        $query = "DELETE FROM batch_obat WHERE id_batch = '$id'";
        $result = mysqli_query($conn, $query);

        echo json_encode([
            'success' => (bool)$result,
            'message' => $result ? '✅ Data batch berhasil dihapus' : '❌ Gagal menghapus data',
            'error' => $result ? null : mysqli_error($conn)
        ]);
        break;

    default:
        echo json_encode(['success' => false, 'message' => 'Method tidak didukung']);
        break;
}
?>
