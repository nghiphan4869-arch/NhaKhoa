import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class NhacLich extends StatefulWidget {
  const NhacLich({super.key});

  @override
  State<NhacLich> createState() => _NhacLichState();
}

class _NhacLichState extends State<NhacLich> {
  int selectedTab = 0; // 0:Tất cả, 1:Sắp tới, 2:Đã qua

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                /// TIÊU ĐỀ
                const Text(
                  "Nhắc lịch hẹn",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// TAB
                Row(
                  children: [
                    Expanded(
                      child: _buildTab(
                        "Tất cả",
                        0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTab(
                        "Sắp tới",
                        1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTab(
                        "Đã qua",
                        2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// SẮP TỚI
                const Text(
                  "Sắp tới",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                _buildAppointmentCard(
                  title: "Lịch hẹn sắp tới",
                  description:
                      "Bạn có lịch hẹn với BS. ABC vào 15:30 hôm nay",
                  time: "15:30",
                  date: "Hôm nay",
                  color: Colors.blue,
                ),

                _buildAppointmentCard(
                  title: "Lịch hẹn sắp tới",
                  description:
                      "Bạn có lịch hẹn với BS. ABC vào 15:00 ngày mai",
                  time: "15:00",
                  date: "Ngày mai",
                  color: Colors.blue,
                ),

                _buildAppointmentCard(
                  title: "Lịch hẹn sắp tới",
                  description:
                      "Bạn có lịch hẹn với BS. ABC vào 10:00 05/06/2026",
                  time: "10:00",
                  date: "05/06/2026",
                  color: Colors.blue,
                ),

                const SizedBox(height: 25),

                /// ĐÃ QUA
                const Text(
                  "Đã qua",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                _buildAppointmentCard(
                  title: "Lịch hẹn đã hoàn thành",
                  description:
                      "Bạn đã khám với BS.ABC vào 10:00 ngày 10/05/2026",
                  time: "10:00",
                  date: "10/05/2026",
                  color: Colors.blue,
                ),

                _buildAppointmentCard(
                  title: "Lịch hẹn đã hoàn thành",
                  description:
                      "Bạn đã khám với BS.ABC vào 10:00 ngày 10/05/2026",
                  time: "10:00",
                  date: "10/05/2026",
                  color: Colors.blue,
                ),

                _buildAppointmentCard(
                  title: "Lịch hẹn đã hoàn thành",
                  description:
                      "Bạn đã khám với BS.ABC vào 10:00 ngày 10/05/2026",
                  time: "10:00",
                  date: "10/05/2026",
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const BottomNav(
        currentIndex: 3,
      ),
    );
  }

  Widget _buildTab(
    String title,
    int index,
  ) {
    bool active = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xff6d8df5)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: active
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String title,
    required String description,
    required String time,
    required String date,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.event_note,
            size: 35,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: color,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}