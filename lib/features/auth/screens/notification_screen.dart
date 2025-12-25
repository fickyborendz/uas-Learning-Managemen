import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return InkWell(
            onTap: () {
              // aksi saat notifikasi diklik
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.icon,
                    size: 28,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.time,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ===========================
   DATA DUMMY NOTIFIKASI
   =========================== */

class NotificationItem {
  final IconData icon;
  final String title;
  final String time;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.time,
  });
}

final List<NotificationItem> _notifications = [
  NotificationItem(
    icon: Icons.assignment,
    title: 'Pengajuan tugas baru tersedia',
    time: '3 Hari 9 Jam Yang Lalu',
  ),
  NotificationItem(
    icon: Icons.quiz,
    title: 'Kuis Matematika telah dimulai',
    time: '1 Hari Yang Lalu',
  ),
  NotificationItem(
    icon: Icons.assignment_turned_in,
    title: 'Tugas Bahasa Indonesia dinilai',
    time: '5 Jam Yang Lalu',
  ),
  NotificationItem(
    icon: Icons.quiz_outlined,
    title: 'Kuis IPA akan berakhir hari ini',
    time: '30 Menit Yang Lalu',
  ),
];
