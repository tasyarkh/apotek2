import 'package:flutter/material.dart';
import '../../models/staff.dart';
import '../../services/api_services.dart';
import 'staff_form_page.dart';

class StaffListPage extends StatefulWidget {
  const StaffListPage({super.key});

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  List<Staff> staffList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
  try {
    final data = await ApiService.getStaffList();
    if (!mounted) return; // ✅ Tambahkan ini
    setState(() {
      staffList = data;
      isLoading = false;
    });
  } catch (e) {
    if (!mounted) return; // ✅ Aman dari error ticker
    debugPrint("Gagal memuat staff: $e");
    setState(() => isLoading = false);
  }
}


  void _hapusStaff(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah kamu yakin ingin menghapus staff ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.hapusStaff(id);
      _loadStaff();
    }
  }

  void _bukaForm({Staff? staff}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StaffFormPage(staff: staff)),
    );

    if (result == true) {
      _loadStaff();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Staff")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : staffList.isEmpty
              ? const Center(child: Text("Belum ada data staff"))
              : ListView.builder(
                  itemCount: staffList.length,
                  itemBuilder: (context, i) {
                    final item = staffList[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        title: Text(item.namaStaff),
                        subtitle: Text("Username: ${item.username}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _bukaForm(staff: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusStaff(item.idStaff ?? 0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
