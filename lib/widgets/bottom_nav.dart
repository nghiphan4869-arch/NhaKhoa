import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/TrangChu.dart';
import 'package:nhakhoa/Screen/CaNhan.dart';
import 'package:nhakhoa/Screen/ThongBao.dart';
import 'package:nhakhoa/Screen/DieuTri.dart';
import 'package:nhakhoa/Screen/LichHen.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LichHen(),
              ),
            );
            break;

          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DieuTri(),
              ),
            );
            break;

          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const TrangChu(),
              ),
            );
            break;

          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ThongBao(),
              ),
            );
            break;

          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CaNhan(),
              ),
            );
            break;
        }
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note),
          label: "Lịch hẹn",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: "Điều trị",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Trang chủ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: "Thông báo",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Cá nhân",
        ),
      ],
    );
  }
}