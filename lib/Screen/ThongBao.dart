import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';
import '../widgets/bottom_nav.dart';

class ThongBao extends StatefulWidget {
  const ThongBao({super.key});

  @override
  State<ThongBao> createState() => _ThongBaoState();
}

class _ThongBaoState extends State<ThongBao> {
  int selectedTab = 0; // 0: Tất cả, 1: Mới, 2: Cũ
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
      print('Lỗi tải lịch hẹn thông báo: $e');
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

  String _formatTime(dynamic timeStr) {
    if (timeStr == null || timeStr.toString().isEmpty) {
      return "Chờ xếp lịch";
    }
    final s = timeStr.toString();
    if (s.length >= 5) {
      return s.substring(0, 5);
    }
    return s;
  }

  bool _isPastAppointment(dynamic app) {
    try {
      final ngayHenStr = app['NgayHen'];
      if (ngayHenStr == null) return false;
      
      // Parse NgayHen và chuyển về giờ địa phương trước
      final localDate = DateTime.parse(ngayHenStr).toLocal();
      
      // GioHen có dạng "14:30:00" hoặc "14:30"
      String gioHenStr = app['GioHen'] ?? '00:00';
      final timeParts = gioHenStr.split(':');
      final int hour = timeParts.isNotEmpty ? int.parse(timeParts[0]) : 0;
      final int minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;
      
      // Kết hợp ngày địa phương với giờ địa phương
      final appDt = DateTime(localDate.year, localDate.month, localDate.day, hour, minute);
      
      return appDt.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  String _getEffectiveStatus(dynamic app) {
    final status = app['TrangThai'] ?? '';
    if (status == 'ChoDuyet' || status == 'DaDuyet' || status == 'DaXacNhan' || status == 'ChoKham') {
      if (_isPastAppointment(app)) {
        return 'DaHetHan';
      }
    }
    return status;
  }

  List<dynamic> get _upcomingAppointments {
    return _appointments.where((app) {
      final gioHen = app['GioHen'];
      if (gioHen == null || gioHen.toString().isEmpty) return false;

      final status = _getEffectiveStatus(app);
      if (status == 'DaHuy' || status == 'DaHetHan' || status == 'DaHoanTat') return false;
      return !_isPastAppointment(app);
    }).toList();
  }

  List<dynamic> get _pastAppointments {
    return _appointments.where((app) {
      final gioHen = app['GioHen'];
      if (gioHen == null || gioHen.toString().isEmpty) return false;

      final status = _getEffectiveStatus(app);
      if (status == 'DaHuy' || status == 'DaHetHan' || status == 'DaHoanTat') return true;
      return _isPastAppointment(app);
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
      case 'DaHetHan':
        return 'đã hết hạn';
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
      case 'DaHetHan':
        return Colors.grey;
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
                      "Vui lòng đăng nhập để xem thông báo",
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
                            "Thông báo",
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
                                  "Mới",
                                  1,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildTab(
                                  "Cũ",
                                  2,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          /// LỊCH HẸN SẮP TỚI
                          if (selectedTab == 0 || selectedTab == 1) ...[
                            const Text(
                              "Thông báo mới",
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
                                       "Chưa có thông báo lịch hẹn sắp tới nào",
                                       style: TextStyle(
                                         color: Colors.grey,
                                         fontStyle: FontStyle.italic,
                                       ),
                                     ),
                                   )
                                : Column(
                                    children: _upcomingAppointments.map((app) {
                                      final doctorName = app['TenBacSi'] ?? _getDoctorName(app['MaBacSi'] ?? 1);
                                      final status = _getEffectiveStatus(app);
                                      final statusLabel = _getStatusLabel(status);
                                      final color = _getStatusColor(status);
                                      final dateText = _formatDate(app['NgayHen']);
                                      final timeText = _formatTime(app['GioHen']);
                                      
                                      return _buildAppointmentCard(
                                        title: "Thông báo sắp tới ($statusLabel)",
                                        description: timeText == "Chờ xếp lịch"
                                            ? "Bạn có lịch hẹn với $doctorName ngày $dateText (đang chờ xếp giờ cụ thể)."
                                            : "Bạn có lịch hẹn với $doctorName vào lúc $timeText ngày $dateText.",
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
                              "Thông báo cũ",
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
                                       "Chưa có thông báo lịch hẹn nào đã qua",
                                       style: TextStyle(
                                         color: Colors.grey,
                                         fontStyle: FontStyle.italic,
                                       ),
                                     ),
                                   )
                                : Column(
                                    children: _pastAppointments.map((app) {
                                      final doctorName = app['TenBacSi'] ?? _getDoctorName(app['MaBacSi'] ?? 1);
                                      final status = _getEffectiveStatus(app);
                                      final statusLabel = _getStatusLabel(status);
                                      final color = _getStatusColor(status);
                                      final dateText = _formatDate(app['NgayHen']);
                                      final timeText = _formatTime(app['GioHen']);
                                      
                                      return _buildAppointmentCard(
                                        title: "Thông báo $statusLabel",
                                        description: timeText == "Chờ xếp lịch"
                                            ? "Lịch hẹn với $doctorName ngày $dateText (chưa xếp giờ cụ thể)."
                                            : "Lịch hẹn với $doctorName vào lúc $timeText ngày $dateText.",
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
