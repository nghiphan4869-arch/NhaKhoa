import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhakhoa/Screen/DatLichHen.dart';
import 'package:nhakhoa/services/lich_hen_service.dart';

class HuyLichHen extends StatefulWidget {
  const HuyLichHen({super.key});

  @override
  State<HuyLichHen> createState() => _HuyLichHenState();
}

class _HuyLichHenState extends State<HuyLichHen> {
  int selectedIndex = 0;
  List<dynamic> _appointments = [];
  bool _isLoading = true;
  int? _maBenhNhan;
  int? _selectedAppointmentId;
  dynamic _selectedAppointment;

  final reasons = [
    {
      "icon": Icons.calendar_month,
      "title": "Không sắp xếp được thời gian",
      "color": Colors.blue,
    },
    {
      "icon": Icons.sentiment_dissatisfied,
      "title": "Sức khỏe không đảm bảo",
      "color": Colors.purple,
    },
    {
      "icon": Icons.car_repair,
      "title": "Có việc đột xuất",
      "color": Colors.orange,
    },
    {
      "icon": Icons.flight,
      "title": "Đi công tác / du lịch",
      "color": Colors.green,
    },
    {
      "icon": Icons.more_horiz,
      "title": "Lý do khác",
      "color": Colors.grey,
    },
  ];

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
        
        // Chỉ lấy lịch hẹn có trạng thái Chờ duyệt (ChoDuyet)
        final activeList = list.where((app) => app['TrangThai'] == 'ChoDuyet').toList();
        
        setState(() {
          _appointments = activeList;
          if (activeList.isNotEmpty) {
            _selectedAppointmentId = activeList.first['MaLichHen'];
            _selectedAppointment = activeList.first;
          } else {
            _selectedAppointmentId = null;
            _selectedAppointment = null;
          }
        });
      }
    } catch (e) {
      print('Lỗi tải lịch hẹn hủy: $e');
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

  String _getStatusLabel(String status) {
    switch (status) {
      case 'ChoDuyet':
        return 'Chờ duyệt';
      case 'DaDuyet':
      case 'DaXacNhan':
        return 'Đã duyệt';
      case 'ChoKham':
        return 'Chờ khám';
      case 'DaHuy':
        return 'Đã hủy';
      default:
        return 'Chờ duyệt';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _infoRow(
      IconData icon,
      String text,
    ) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Hủy lịch hẹn",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Vui lòng xác nhận thông tin và lý do hủy lịch hẹn.",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// DROPDOWN LỰA CHỌN LỊCH HẸN
                  if (_appointments.isNotEmpty) ...[
                    const Text(
                      "Chọn lịch hẹn cần hủy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: _selectedAppointmentId,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      isExpanded: true,
                      items: _appointments.map((app) {
                        final date = _formatDate(app['NgayHen']);
                        final time = _formatTime(app['GioHen']);
                        final doc = _getDoctorName(app['MaBacSi'] ?? 1);
                        final reason = (app['LyDoKham'] ?? '').split(':')[0].trim();
                        return DropdownMenuItem<int>(
                          value: app['MaLichHen'],
                          child: Text("$reason - $doc ($time $date)"),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedAppointmentId = val;
                          _selectedAppointment = _appointments.firstWhere((app) => app['MaLichHen'] == val);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  /// THÔNG TIN LỊCH
                  const Text(
                    "Thông tin lịch hẹn",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (_selectedAppointment == null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Text(
                          "Bạn không có lịch hẹn nào đang hoạt động.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(.03),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          /// Header
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.calendar_month,
                                  size: 38,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (_selectedAppointment['LyDoKham'] ?? '').split(':')[0].trim(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _selectedAppointment['TrangThai'] == 'ChoDuyet'
                                            ? Colors.orange.shade50
                                            : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _selectedAppointment['TrangThai'] == 'ChoDuyet'
                                                ? Icons.schedule
                                                : Icons.verified,
                                            color: _selectedAppointment['TrangThai'] == 'ChoDuyet'
                                                ? Colors.orange
                                                : Colors.blue,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            _getStatusLabel(_selectedAppointment['TrangThai'] ?? ''),
                                            style: TextStyle(
                                              color: _selectedAppointment['TrangThai'] == 'ChoDuyet'
                                                  ? Colors.orange.shade800
                                                  : Colors.blue.shade800,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),

                          _infoRow(
                            Icons.person_outline,
                            _getDoctorName(_selectedAppointment['MaBacSi'] ?? 1),
                          ),
                          _infoRow(
                            Icons.calendar_today,
                            _formatDate(_selectedAppointment['NgayHen'] ?? ''),
                          ),
                          _infoRow(
                            Icons.access_time,
                            _formatTime(_selectedAppointment['GioHen'] ?? ''),
                          ),
                          _infoRow(
                            Icons.location_on_outlined,
                            " Smile Care - Cơ sở 1\n123 Nguyễn Trãi, Q1, TP.HCM",
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.blue.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DatLichHen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.blue,
                      ),
                      label: const Text(
                        "Chọn lịch khác",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Bạn có thể hủy lịch hẹn trước ít nhất 2 giờ.",
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Lý do hủy lịch hẹn",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...List.generate(
                    reasons.length,
                    (index) {
                      final item = reasons[index];
                      bool selected = selectedIndex == index;

                      return GestureDetector(
                        onTap: _selectedAppointment == null
                            ? null
                            : () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected && _selectedAppointment != null
                                  ? Colors.blue
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: (item["color"] as Color).withOpacity(.1),
                                child: Icon(
                                  item["icon"] as IconData,
                                  color: item["color"] as Color,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  item["title"] as String,
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Radio<int>(
                                value: index,
                                groupValue: selectedIndex,
                                onChanged: _selectedAppointment == null
                                    ? null
                                    : (value) {
                                        setState(() {
                                          selectedIndex = value!;
                                        });
                                      },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Ghi chú thêm (không bắt buộc)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    maxLines: 4,
                    maxLength: 200,
                    enabled: _selectedAppointment != null,
                    decoration: InputDecoration(
                      hintText: "Nhập ghi chú của bạn...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Lưu ý",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Text("• Lịch hẹn sẽ được hủy sau khi xác nhận"),
                        SizedBox(height: 5),
                        Text("• Bạn có thể đặt lịch mới bất kỳ lúc nào")
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _selectedAppointment == null
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Row(
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Xác nhận hủy",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                      "Bạn có chắc chắn muốn hủy lịch hẹn này không?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Quay lại",
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(context); // Close dialog

                                          if (_selectedAppointmentId == null) return;

                                          setState(() {
                                            _isLoading = true;
                                          });

                                          final success = await LichHenService.cancelAppointment(_selectedAppointmentId!);

                                          setState(() {
                                            _isLoading = false;
                                          });

                                          if (success) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Đã hủy lịch hẹn thành công",
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            Navigator.pop(context); // Back to previous page
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Lỗi: Không thể hủy lịch hẹn. Vui lòng thử lại sau.",
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Xác nhận",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Xác nhận hủy lịch",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Quay lại",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}