import 'package:flutter/material.dart';
import 'package:nhakhoa/Screen/DatLichHen.dart';
import 'package:nhakhoa/Screen/DieuTri.dart';
import 'package:nhakhoa/Screen/NhacLichHen.dart';
import 'package:nhakhoa/Screen/DangNhap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';
import 'package:nhakhoa/services/theo_doi_service.dart';
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

  List<dynamic> get _pendingAppointments {
    return _appointments.where((app) => _getEffectiveStatus(app) == 'ChoDuyet').toList();
  }

  List<dynamic> get _approvedAppointments {
    return _appointments.where((app) {
      final status = _getEffectiveStatus(app);
      return status == 'DaDuyet' || status == 'DaXacNhan' || status == 'ChoKham';
    }).toList();
  }

  List<dynamic> get _completedAppointments {
    return _appointments.where((app) {
      final status = _getEffectiveStatus(app);
      return status == 'DaHoanTat' || status == 'DaHuy' || status == 'DaHetHan';
    }).toList();
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
                              Expanded(child: _buildTab("Lịch sử", 2)),
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
                                    final status = _getEffectiveStatus(app);

                                    // Choose a background color based on status
                                    Color cardColor = const Color(0xffedf5ff); // Default blue-ish
                                    if (status == 'ChoDuyet') {
                                      cardColor = const Color(0xfffff7eb); // Orange-ish
                                    } else if (status == 'DaHoanTat') {
                                      cardColor = const Color(0xfff0fbf0); // Green-ish
                                    } else if (status == 'DaHetHan' || status == 'DaHuy') {
                                      cardColor = Colors.grey.shade100; // Grey-ish
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: _appointmentCard(
                                        color: cardColor,
                                        time: "${_formatDate(app['NgayHen'])} • ${_formatTime(app['GioHen'])}",
                                        doctor: _getDoctorName(app['MaBacSi'] ?? 1),
                                        note: app['LyDoKham'] ?? 'Không có lý do',
                                        status: status,
                                        onFeedbackPressed: status == 'DaHoanTat'
                                            ? () => _showFeedbackDialog(
                                                app['MaLichHen'],
                                                _getDoctorName(app['MaBacSi'] ?? 1),
                                              )
                                            : null,
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
    VoidCallback? onFeedbackPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          if (status == 'DaHoanTat' && onFeedbackPressed != null) ...[
            const SizedBox(height: 10),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onFeedbackPressed,
                icon: const Icon(Icons.feedback_outlined, size: 16),
                label: const Text(
                  "Ph\u1ea3n h\u1ed3i s\u1ee9c kh\u1ecfe",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.teal.shade800,
                  backgroundColor: Colors.teal.shade100.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
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
      case 'DaHetHan':
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade600;
        label = 'Đã hết hạn';
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

  Future<void> _showFeedbackDialog(int maLichHen, String doctorName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final sheet = await TheoDoiService.getOrCreateTrackingSheet(maLichHen);
    
    if (mounted) Navigator.pop(context);

    if (sheet == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Th\u00f4ng b\u00e1o"),
            content: const Text("Kh\u00f4ng th\u1ec3 t\u1ea3i th\u00f4ng tin b\u1ec7nh \u00e1n \u0111\u1ec3 ph\u1ea3n h\u1ed3i. Vui l\u00f2ng th\u1eed l\u1ea1i sau."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("\u0110\u00f3ng"),
              )
            ],
          ),
        );
      }
      return;
    }

    final int maTheoDoi = sheet['MaTheoDoi'];
    int currentPainLevel = sheet['MucDoDau'] ?? 1;
    final TextEditingController textController1 = TextEditingController(text: sheet['TinhTrangSauDungThuoc'] ?? '');
    final TextEditingController textController2 = TextEditingController(text: sheet['PhanHoiBenhNhan'] ?? '');

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  const Icon(Icons.favorite_outline, color: Colors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Ph\u1ea3n h\u1ed3i s\u1ee9c kh\u1ecfe",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "L\u1ecbch h\u1eb9n v\u1edbi: $doctorName",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "M\u1ee9c \u0111\u1ed9 \u0111au (1: B\u00ecnh th\u01b0\u1eddng - 5: \u0110au nhi\u1ec1u):",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final val = index + 1;
                        final isSelected = currentPainLevel == val;
                        return ChoiceChip(
                          label: Text("$val"),
                          selected: isSelected,
                          selectedColor: Colors.teal.shade100,
                          onSelected: (selected) {
                            if (selected) {
                              setDialogState(() {
                                currentPainLevel = val;
                              });
                            }
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "T\u00ecnh tr\u1ea1ng sau d\u00f9ng thu\u1ed1c:",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: textController1,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Nh\u1eadp c\u1ea3m gi\u00e1c, t\u00ecnh tr\u1ea1ng sau u\u1ed1ng thu\u1ed1c...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "\u00dd ki\u1ebfn ph\u1ea3n h\u1ed3i kh\u00e1c:",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: textController2,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Nh\u1eadp ph\u1ea3n h\u1ed3i, c\u00e2u h\u1ecfi cho b\u00e1c s\u0129...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Hu\u1ef7", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    final res = await TheoDoiService.sendFeedback(
                      maTheoDoi: maTheoDoi,
                      mucDoDau: currentPainLevel,
                      tinhTrangSauDungThuoc: textController1.text.trim(),
                      phanHoiBenhNhan: textController2.text.trim(),
                    );

                    if (mounted) Navigator.pop(context);

                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(res ? "Th\u00e0nh c\u00f4ng" : "Th\u1ea5t b\u1ea1i"),
                          content: Text(res
                              ? "C\u1ea3m \u01a1n b\u1ea1n \u0111\u00e3 ph\u1ea3n h\u1ed3i t\u00ecnh tr\u1ea1ng s\u1ee9c kh\u1ecfe."
                              : "G\u1eedi ph\u1ea3n h\u1ed3i th\u1ea5t b\u1ea1i. Vui l\u00f2ng th\u1eed l\u1ea1i sau."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("\u0110\u1ed3ng \u00fd"),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("G\u1eedi ph\u1ea3n h\u1ed3i"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}