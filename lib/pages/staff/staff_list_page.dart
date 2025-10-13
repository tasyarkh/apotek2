import 'package:flutter/material.dart';
import '../../models/staff.dart';
import 'staff_form_page.dart';

class StaffListPage extends StatefulWidget {
  const StaffListPage({super.key});

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  List<Staff> staffList = [
    Staff(id: 1, namaStaff: 'Andi Setiawan', username: 'andi', password: '12345'),
    Staff(id: 2, namaStaff: 'Budi Santoso', username: 'budi', password: 'abcd'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D4E),
        title: const Text(
          "Data Staff",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: staffList.length,
        itemBuilder: (context, index) {
          final s = staffList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(s.namaStaff, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Username: ${s.username}'),
              trailing: const Icon(Icons.person),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE84C3D),
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StaffFormPage()),
          );
          if (result != null && result is Staff) {
            setState(() {
              staffList.add(result);
            });
          }
        },
      ),
    );
  }
}
