import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';
import '../widgets/bottom_nav.dart';

class NhacLich extends StatefulWidget {
  const NhacLich({super.key});

  @override
  State<NhacLich> createState() => _NhacLichState();
}

class _NhacLichState extends State<NhacLich> {
  int selectedTab = 0; // 0: Tất cả, 1: Sắp tới, 2: Đã qua
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
      print('Lỗi tải lịch hẹn nhắc lịch: $e');
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
      case 3:
        return "BS. Nguyễn Văn A";
      case 4:
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

  String _getStatusLabel(String status) {
    switch (status) {
      case 'ChoDuyet':
        return 'chờ duyệt';
      case 'DaXacNhan':
      case 'DaDuyet':
        return 'đã xác nhận';
      case 'ChoKham':
        return 'chờ khám';
      case 'DaHuy':
        return 'đã hủy';
      default:
        return 'chờ duyệt';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ChoDuyet':
        return Colors.orange;
      case 'DaXacNhan':
      case 'DaDuyet':
      case 'ChoKham':
        return Colors.blue;
      case 'DaHuy':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _maBenhNhan == null
                ? const Center(
                    child: Text(
                      "Vui lòng đăng nhập để xem nhắc lịch",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadAppointments,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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

                          /// LỊCH HẸN SẮP TỚI
                          if (selectedTab == 0 || selectedTab == 1) ...[
                            const Text(
                              "Sắp tới",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _upcomingAppointments.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "Chưa có lịch hẹn sắp tới nào",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: _upcomingAppointments.map((app) {
                                      final doctorName = _getDoctorName(app['MaBacSi'] ?? 1);
                                      final statusLabel = _getStatusLabel(app['TrangThai'] ?? '');
                                      final color = _getStatusColor(app['TrangThai'] ?? '');
                                      final dateText = _formatDate(app['NgayHen']);
                                      final timeText = _formatTime(app['GioHen']);
                                      
                                      return _buildAppointmentCard(
                                        title: "Lịch hẹn sắp tới ($statusLabel)",
                                        description: "Bạn có lịch hẹn với $doctorName vào lúc $timeText ngày $dateText.",
                                        time: timeText,
                                        date: dateText,
                                        color: color,
                                      );
                                    }).toList(),
                                  ),
                            const SizedBox(height: 25),
                          ],

                          /// LỊCH HẸN ĐÃ QUA
                          if (selectedTab == 0 || selectedTab == 2) ...[
                            const Text(
                              "Đã qua",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _pastAppointments.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "Chưa có lịch hẹn nào đã qua",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: _pastAppointments.map((app) {
                                      final doctorName = _getDoctorName(app['MaBacSi'] ?? 1);
                                      final statusLabel = _getStatusLabel(app['TrangThai'] ?? '');
                                      final color = _getStatusColor(app['TrangThai'] ?? '');
                                      final dateText = _formatDate(app['NgayHen']);
                                      final timeText = _formatTime(app['GioHen']);
                                      
                                      return _buildAppointmentCard(
                                        title: "Lịch hẹn $statusLabel",
                                        description: "Lịch hẹn với $doctorName vào lúc $timeText ngày $dateText.",
                                        time: timeText,
                                        date: dateText,
                                        color: color,
                                      );
                                    }).toList(),
                                  ),
                          ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.event_note,
            size: 35,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
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