<?php
include 'db.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    // =========================================================
    // 🟢 GET (Ambil data staff)
    // =========================================================
    case 'GET':
        if (isset($_GET['id_staff'])) {
            $id = intval($_GET['id_staff']);
            $query = "SELECT id_staff, nama_staff, username FROM staff WHERE id_staff = $id";
            $result = mysqli_query($conn, $query);

            if ($result && mysqli_num_rows($result) > 0) {
                $data = mysqli_fetch_assoc($result);
                echo json_encode(['success' => true, 'data' => $data]);
            } else {
                echo json_encode(['success' => false, 'message' => 'Data tidak ditemukan']);
            }
        } else {
            $query = "SELECT id_staff, nama_staff, username FROM staff ORDER BY id_staff DESC";
            $result = mysqli_query($conn, $query);
            $data = [];

            if ($result) {
                while ($row = mysqli_fetch_assoc($result)) {
                    $data[] = $row;
                }
            }

            echo json_encode(['success' => true, 'data' => $data]);
        }
        break;

    // =========================================================
    // 🟡 POST (Tambah staff)
    // =========================================================
    case 'POST':
        $nama = $_POST['nama_staff'] ?? '';
        $username = $_POST['username'] ?? '';
        $password = $_POST['password'] ?? '';

        if (empty($nama) || empty($username) || empty($password)) {
            echo json_encode(['success' => false, 'message' => 'Semua field wajib diisi']);
            exit;
        }

        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

        $query = "INSERT INTO staff (nama_staff, username, password)
                  VALUES ('$nama', '$username', '$hashedPassword')";
        $result = mysqli_query($conn, $query);

        if ($result) {
            echo json_encode(['success' => true, 'message' => 'Data staff berhasil ditambahkan']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Gagal menambah data staff']);
        }
        break;

    // =========================================================
    // 🟠 PUT (Update staff)
    // =========================================================
    case 'PUT':
        parse_str(file_get_contents("php://input"), $_PUT);
        $id = $_GET['id'] ?? null;

        if (!$id) {
            echo json_encode(['success' => false, 'message' => 'ID tidak ditemukan']);
            exit;
        }

        $nama = $_PUT['nama_staff'] ?? '';
        $username = $_PUT['username'] ?? '';
        $password = $_PUT['password'] ?? '';

        if (empty($nama) || empty($username)) {
            echo json_encode(['success' => false, 'message' => 'Nama dan username wajib diisi']);
            exit;
        }

        if (!empty($password)) {
            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
            $query = "UPDATE staff SET 
                        nama_staff = '$nama',
                        username = '$username',
                        password = '$hashedPassword'
                      WHERE id_staff = '$id'";
        } else {
            $query = "UPDATE staff SET 
                        nama_staff = '$nama',
                        username = '$username'
                      WHERE id_staff = '$id'";
        }

        $result = mysqli_query($conn, $query);

        if ($result) {
            echo json_encode(['success' => true, 'message' => 'Data staff berhasil diupdate']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Gagal update data staff']);
        }
        break;

    // =========================================================
    // 🔴 DELETE (Hapus staff)
    // =========================================================
    case 'DELETE':
        $id = $_GET['id'] ?? null;

        if (!$id) {
            echo json_encode(['success' => false, 'message' => 'ID tidak ditemukan']);
            exit;
        }

        $query = "DELETE FROM staff WHERE id_staff = '$id'";
        $result = mysqli_query($conn, $query);

        if ($result) {
            echo json_encode(['success' => true, 'message' => 'Data staff berhasil dihapus']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Gagal menghapus data staff']);
        }
        break;

    // =========================================================
    // ⚪ DEFAULT (Jika method tidak didukung)
    // =========================================================
    default:
        echo json_encode(['success' => false, 'message' => 'Method tidak didukung']);
        break;
}

mysqli_close($conn);
?>
