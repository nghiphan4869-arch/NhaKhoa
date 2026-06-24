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
  List<dynamic> _appointments = [];
  bool _isLoading = true;
  int? _maBenhNhan;
  int selectedTab = 0; // 0: Chờ duyệt, 1: Đã duyệt, 2: Đã hoàn tất

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

  List<dynamic> get _pendingAppointments {
    return _appointments.where((app) => app['TrangThai'] == 'ChoDuyet').toList();
  }

  List<dynamic> get _approvedAppointments {
    return _appointments.where((app) => app['TrangThai'] == 'DaDuyet' || app['TrangThai'] == 'DaXacNhan' || app['TrangThai'] == 'ChoKham').toList();
  }

  List<dynamic> get _completedAppointments {
    return _appointments.where((app) => app['TrangThai'] == 'DaHoanTat').toList();
  }

  List<dynamic> _getActiveAppointmentsList() {
    switch (selectedTab) {
      case 0:
        return _pendingAppointments;
      case 1:
        return _approvedAppointments;
      case 2:
        return _completedAppointments;
      default:
        return [];
    }
  }

  Widget _buildTab(String title, int index) {
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
          color: active ? const Color(0xff6d8df5) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

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
                            ],
                          ),



                          const SizedBox(height: 20),

                          /// TABS
                          Row(
                            children: [
                              Expanded(child: _buildTab("Chờ duyệt", 0)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildTab("Đã duyệt", 1)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildTab("Đã hoàn tất", 2)),
                            ],
                          ),

                          const SizedBox(height: 20),

                          _getActiveAppointmentsList().isEmpty
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
                                      "Không có lịch hẹn nào",
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
                                  itemCount: _getActiveAppointmentsList().length,
                                  itemBuilder: (context, index) {
                                    final app = _getActiveAppointmentsList()[index];
                                    final status = app['TrangThai'] ?? '';
                                    
                                    // Choose a background color based on status
                                    Color cardColor = const Color(0xffedf5ff); // Default blue-ish
                                    if (status == 'ChoDuyet') {
                                      cardColor = const Color(0xfffff7eb); // Orange-ish
                                    } else if (status == 'DaHoanTat') {
                                      cardColor = const Color(0xfff0fbf0); // Green-ish
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: _appointmentCard(
                                        color: cardColor,
                                        time: "${_formatDate(app['NgayHen'])} • ${_formatTime(app['GioHen'])}",
                                        doctor: _getDoctorName(app['MaBacSi'] ?? 1),
                                        note: app['LyDoKham'] ?? 'Không có lý do',
                                        status: status,
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
      case 'DaDuyet':
      case 'DaXacNhan':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade800;
        label = 'Đã duyệt';
        break;
      case 'ChoKham':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        label = 'Chờ khám';
        break;
      case 'DaHoanTat':
        bgColor = Colors.teal.shade50;
        textColor = Colors.teal.shade800;
        label = 'Đã hoàn tất';
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