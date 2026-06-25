import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/CapNhatTinhTrang.dart';
import 'package:nhakhoa/Screen/DatLichHen.dart';
import 'package:nhakhoa/Screen/DieuTri.dart';
import 'package:nhakhoa/Screen/DonThuoc.dart';
import 'package:nhakhoa/Screen/LichHen.dart';
import 'package:nhakhoa/Screen/PhanHoi.dart';
import 'package:nhakhoa/Screen/TaiKham.dart';
import 'package:nhakhoa/Screen/HuyLichHen.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/menu_card.dart';
import '../widgets/section_title.dart';
import '../widgets/bottom_nav.dart';

class TrangChu extends StatelessWidget {
  const TrangChu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 245, 242, 242),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(16),
          child: Column(    
            children: [

                const HomeHeader(),

              const SizedBox(height: 20),

              const HomeBanner(),

              const SizedBox(height: 25),

              const SectionTitle(
                title: "Lịch hẹn",
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  MenuCard(
                    icon: Icons.event_available,
                    title: "Đặt lịch khám",
                    color: const Color(0xffefe5f2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DatLichHen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  MenuCard(
                    icon: Icons.calendar_month,
                    title: "Xem lịch hẹn",
                    color:
                        const Color(0xffefe5f2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LichHen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  MenuCard(
                    icon: Icons.event_busy,
                    title: "Hủy lịch hẹn",
                    color:
                        const Color(0xffefe5f2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HuyLichHen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const SectionTitle(
                title: "Điều trị",
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  MenuCard(
                    icon:
                        Icons.health_and_safety,
                    title:
                        "Tiến trình điều trị",
                    color:
                        const Color(0xffdff0e6),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DieuTri(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  MenuCard(
                    icon: Icons.medication,
                    title: "Đơn thuốc",
                    color:
                        const Color(0xffdff0e6),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DonThuoc(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  MenuCard(
                    icon: Icons.refresh,
                    title: "Tái khám",
                    color:
                        const Color(0xffdff0e6),
                        onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaiKham(),
                        ),
                      );
                    },
                  ),
                ],
              ),
               const SizedBox(height: 25),

              const SectionTitle(
                title: "Phản hồi sức khỏe",
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  MenuCard(
                    icon:
                        Icons.feedback_outlined,
                    title:
                        "Phản hồi",
                    color:
                        const Color(0xffefe5d8),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PhanHoi(),),);
                    },
                  ),
                  const SizedBox(width: 10),
                  MenuCard(
                    icon: Icons.health_and_safety_outlined,
                    title: "Cập nhật tình trạng",
                    color:
                        const Color(0xffefe5d8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CapNhatTinhTrang(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  MenuCard(
                    icon: Icons.image_outlined,
                    title: "Upload hình ảnh",
                    color:
                        const Color(0xffefe5d8),
                  ),
                ],
              ),
            ],
          ),
        ),
            ),
      bottomNavigationBar: const BottomNav(
        currentIndex: 2,
      ),
    );
  }
}