import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/DatLichHen.dart';
import 'package:nhakhoa/Screen/DieuTri.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';
import 'package:nhakhoa/Screen/DangNhap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';
import '../widgets/bottom_nav.dart';

class LichHen extends StatefulWidget {
  const LichHen({super.key});

  @override
  State<LichHen> createState() =>
      _LichHenState();
}

class _LichHenState extends State<LichHen> {
  DateTime selectedDay = DateTime.now();
  int startIndex = 0;

  List<dynamic> _appointments = [];
  bool _isLoading = true;
  int? _maBenhNhan;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final maBn = prefs.getInt('maBenhNhan');
      if (maBn != null && maBn > 0) {
        _maBenhNhan = maBn;
        final list = await LichHenService.getAppointmentsByPatient(maBn);
        setState(() {
          _appointments = list;
        });
      } else {
        setState(() {
          _maBenhNhan = null;
        });
      }
    } catch (e) {
      print('Lỗi tải lịch hẹn: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getDoctorName(int maBacSi) {
    switch (maBacSi) {
      case 1:
        return "BS. Trần Thùy Dương";
      case 2:
        return "BS. Nguyễn Văn A";
      case 3:
        return "BS. Lê Thị B";
      default:
        return "Bác sĩ Nha Khoa";
    }
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    if (timeStr.length >= 5) {
      return timeStr.substring(0, 5);
    }
    return timeStr;
  }

  List<dynamic> get _upcomingAppointments {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _appointments.where((app) {
      if (app['TrangThai'] == 'DaHuy') return false;
      try {
        final ngayHenStr = app['NgayHen'];
        if (ngayHenStr == null) return false;
        final dt = DateTime.parse(ngayHenStr).toLocal();
        final appointmentDay = DateTime(dt.year, dt.month, dt.day);
        return appointmentDay.isAfter(today) || appointmentDay.isAtSameMomentAs(today);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  List<dynamic> get _pastAppointments {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _appointments.where((app) {
      if (app['TrangThai'] == 'DaHuy') return true;
      try {
        final ngayHenStr = app['NgayHen'];
        if (ngayHenStr == null) return true;
        final dt = DateTime.parse(ngayHenStr).toLocal();
        final appointmentDay = DateTime(dt.year, dt.month, dt.day);
        return appointmentDay.isBefore(today);
      } catch (e) {
        return true;
      }
    }).toList();
  }

  final List<String> thu = [
    "T2","T3","T4","T5","T6","T7","CN"
  ];

  List<DateTime> get dates =>
      List.generate(
        365,
        (index) => DateTime.now().add(
          Duration(days: index),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      bottomNavigationBar: const BottomNav(
        currentIndex: 0,
      ),

      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _maBenhNhan == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Vui lòng đăng nhập để xem lịch hẹn",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const DangNhap()),
                              (route) => false,
                            );
                          },
                          child: const Text("Đăng nhập"),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadAppointments,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Lịch hẹn",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Quản lý lịch hẹn khám và điều trị",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NhacLich(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.notifications_none,
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// MENU
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _menu(
                                context,
                                Icons.calendar_today,
                                Colors.blue,
                                "Đặt lịch",
                                const DatLichHen(),
                              ),
                              _menu(
                                context,
                                Icons.medical_services,
                                Colors.green,
                                "Lịch điều trị",
                                const DieuTri(),
                              ),
                              _menu(
                                context,
                                Icons.schedule,
                                Colors.orange,
                                "Lịch hẹn",
                                null,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// LỊCH
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Tháng ${selectedDay.month}, ${selectedDay.year}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDay = DateTime.now();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffedf5ff),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Hôm nay",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                SizedBox(
                                  height: 70,
                                  child: Row(
                                    children: [
                                      /// Mũi tên trái
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: startIndex > 0
                                              ? () {
                                                  setState(() {
                                                    startIndex -= 7;
                                                  });
                                                }
                                              : null,
                                          icon: const Icon(
                                            Icons.chevron_left,
                                            size: 16,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      /// Danh sách ngày
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 7,
                                          itemBuilder: (context, index) {
                                            final date = dates[startIndex + index];
                                            bool selected = selectedDay.day == date.day &&
                                                selectedDay.month == date.month &&
                                                selectedDay.year == date.year;

                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedDay = date;
                                                });
                                              },
                                              child: Container(
                                                width: 55,
                                                margin: const EdgeInsets.only(right: 8),
                                                decoration: BoxDecoration(
                                                  color: selected ? Colors.blue : Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: selected ? Colors.blue : Colors.grey.shade300,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      thu[date.weekday - 1],
                                                      style: TextStyle(
                                                        color: selected ? Colors.white : Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      "${date.day}/${date.month}",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: selected ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      /// Mũi tên phải
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            setState(() {
                                              startIndex += 7;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.chevron_right,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Lịch hẹn sắp tới",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          _upcomingAppointments.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Chưa có lịch hẹn sắp tới nào",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _upcomingAppointments.length,
                                  itemBuilder: (context, index) {
                                    final app = _upcomingAppointments[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: _appointmentCard(
                                        color: const Color(0xffedf5ff),
                                        time: "${_formatDate(app['NgayHen'])} • ${_formatTime(app['GioHen'])}",
                                        doctor: _getDoctorName(app['MaBacSi'] ?? 1),
                                        note: app['LyDoKham'] ?? 'Không có lý do',
                                        status: app['TrangThai'] ?? '',
                                      ),
                                    );
                                  },
                                ),

                          const SizedBox(height: 15),

                          const Text(
                            "Lịch hẹn đã qua",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          _pastAppointments.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Chưa có lịch hẹn đã qua",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _pastAppointments.length,
                                  itemBuilder: (context, index) {
                                    final app = _pastAppointments[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: _appointmentCard(
                                        color: const Color(0xffeefbea),
                                        time: "${_formatDate(app['NgayHen'])} • ${_formatTime(app['GioHen'])}",
                                        doctor: _getDoctorName(app['MaBacSi'] ?? 1),
                                        note: app['LyDoKham'] ?? 'Không có lý do',
                                        status: app['TrangThai'] ?? '',
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    Widget? page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        if (page == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard({
    required Color color,
    required String time,
    required String doctor,
    required String note,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _statusTag(status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  doctor,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  note,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusTag(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'ChoDuyet':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        label = 'Chờ duyệt';
        break;
      case 'DaXacNhan':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade800;
        label = 'Đã xác nhận';
        break;
      case 'ChoKham':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        label = 'Chờ khám';
        break;
      case 'DaHuy':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        label = 'Đã hủy';
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        label = status.isNotEmpty ? status : 'Chờ duyệt';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}